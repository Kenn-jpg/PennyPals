//
//  NotificationManager.swift
//  PennyPals
//
//  Created by Kelompok 8 on 03/06/26.
//

internal import Combine
import UIKit
import UserNotifications

/// Singleton manager untuk mengelola semua Local Notifications di PennyPals.
/// Menangani proses request permission, penjadwalan (scheduling), dan pembatalan notifikasi.
class NotificationManager: NSObject, ObservableObject,
    UNUserNotificationCenterDelegate
{

    /// Instansiasi tunggal (Singleton) yang digunakan di seluruh siklus hidup aplikasi.
    static let shared = NotificationManager()

    /// Status reaktif yang menandakan apakah pengguna telah memberikan izin notifikasi.
    @Published var isAuthorized: Bool = false

    private enum NotificationID {
        static let dailyReminder = "pennypals.daily.reminder"
        static let penaltyWarning = "pennypals.penalty.warning"
        static let petHungry = "pennypals.pet.hungry"
    }

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorizationStatus()
    }

    /// Meminta izin otorisasi dari pengguna untuk menampilkan notifikasi berupa alert, badge, dan suara.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    print("🔔 Notification permission granted")
                    self?.scheduleDailyReminder()
                } else {
                    print(
                        "🔕 Notification permission denied: \(error?.localizedDescription ?? "Unknown")"
                    )
                }
            }
        }
    }

    /// Mengecek status izin notifikasi saat ini dari pengaturan sistem iOS perangkat.
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings {
            [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    /// Menjadwalkan pengingat harian secara rutin setiap pukul 08:00 pagi agar pengguna ingat untuk menabung.
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Hey, ayo nabung! 🐾"
        content.body =
            "Pet kamu sudah lapar nih! Yuk buka PennyPals dan tabung uangmu hari ini biar dia senang! 😊"
        content.sound = .default
        content.categoryIdentifier = "DAILY_REMINDER"

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: NotificationID.dailyReminder,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(
                    "🔕 Failed to schedule daily reminder: \(error.localizedDescription)"
                )
            } else {
                print("🔔 Daily reminder scheduled for 08:00 every day")
            }
        }
    }

    /// Menjadwalkan peringatan krisis 6 jam sebelum batas waktu pemeriksaan penalti tiba.
    /// - Parameters:
    ///   - nextPenaltyCheck: Tanggal dan waktu batas akhir tabungan pengguna.
    ///   - petName: Nama panggilan hewan peliharaan pengguna.
    func schedulePenaltyWarning(nextPenaltyCheck: Date, petName: String) {
        guard
            let warningDate = Calendar.current.date(
                byAdding: .hour,
                value: -6,
                to: nextPenaltyCheck
            )
        else { return }

        // Mencegah penjadwalan jika waktu peringatan sudah berlalu
        guard warningDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "⚠️ Penalti Mendekat!"
        content.body =
            "\(petName) bakal sedih kalau kamu nggak nabung sebelum tengah malam! Yuk buka PennyPals sekarang 💰"
        content.sound = .default
        content.categoryIdentifier = "PENALTY_WARNING"

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: warningDate
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: NotificationID.penaltyWarning,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [NotificationID.penaltyWarning]
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(
                    "🔕 Failed to schedule penalty warning: \(error.localizedDescription)"
                )
            } else {
                print("🔔 Penalty warning scheduled for \(warningDate)")
            }
        }
    }

    /// Mengirimkan notifikasi seketika (instan) yang memberi tahu pengguna bahwa pet mereka kelaparan karena belum menabung di hari baru.
    /// - Parameter petName: Nama panggilan hewan peliharaan pengguna.
    func sendPetHungryNotification(petName: String) {
        let content = UNMutableNotificationContent()
        content.title = "\(petName) lapar! 🥺"
        content.body =
            "Hari baru sudah dimulai dan kamu belum menabung. Yuk kasih makan \(petName) dengan menabung sekarang!"
        content.sound = .default
        content.categoryIdentifier = "PET_HUNGRY"

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 2,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: NotificationID.petHungry,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// Menjadwalkan pengingat malam pada pukul 20:00 jika pengguna belum menabung pada hari tersebut.
    /// - Parameter petName: Nama panggilan hewan peliharaan pengguna.
    func scheduleEveningReminder(petName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🌙 Jangan lupa nabung malam ini!"
        content.body =
            "\(petName) masih menunggu kamu hari ini. Yuk sempatin nabung sebelum tidur! 💤"
        content.sound = .default
        content.categoryIdentifier = "EVENING_REMINDER"

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "pennypals.evening.reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(
                    "🔕 Failed to schedule evening reminder: \(error.localizedDescription)"
                )
            } else {
                print("🔔 Evening reminder scheduled for 20:00")
            }
        }
    }

    /// Membatalkan notifikasi peringatan kelaparan pet dan pengingat malam hari secara spesifik (digunakan ketika pengguna sudah menabung di hari itu).
    func cancelDailyRemindersForToday() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [NotificationID.petHungry]
        )
        UNUserNotificationCenter.current().removeDeliveredNotifications(
            withIdentifiers: [
                "pennypals.evening.reminder",
                NotificationID.petHungry,
            ]
        )
    }

    /// Membatalkan secara paksa seluruh notifikasi lokal, baik yang sedang dijadwalkan maupun yang sudah terkirim (digunakan saat proses Logout).
    func cancelAllNotifications() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("🔕 All notifications cancelled")
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Memastikan banner dan suara tetap muncul meski aplikasi sedang aktif dibuka (Foreground)
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("🔔 User tapped notification: \(identifier)")
        completionHandler()
    }
}
