//
//  NotificationManager.swift
//  PennyPals
//
//  Created by Kelompok 8 on 03/06/26.
//

import UserNotifications
import UIKit
internal import Combine

/// Singleton manager untuk mengelola semua Local Notifications di PennyPals.
/// Menangani permission request, scheduling, dan pembatalan notifikasi.
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    @Published var isAuthorized: Bool = false

    // MARK: - Notification Identifiers
    private enum NotificationID {
        static let dailyReminder = "pennypals.daily.reminder"
        static let penaltyWarning = "pennypals.penalty.warning"
        static let petHungry = "pennypals.pet.hungry"
        static let streakCelebration = "pennypals.streak.celebration"
        static let levelUp = "pennypals.level.up"
        static let goalProgress = "pennypals.goal.progress"
        static let goalCompleted = "pennypals.goal.completed"
    }

    // MARK: - Initialization

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkAuthorizationStatus()
    }

    // MARK: - Permission Handling

    /// Minta izin notifikasi dari user
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    print("🔔 Notification permission granted")
                    // Schedule daily reminder otomatis setelah izin diberikan
                    self?.scheduleDailyReminder()
                } else {
                    print("🔕 Notification permission denied: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }

    /// Cek status izin notifikasi saat ini
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    // MARK: - 1. Daily Savings Reminder

    /// Jadwalkan pengingat harian untuk menabung
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Hey, ayo nabung! 🐾"
        content.body = "Pet kamu sudah lapar nih! Yuk buka PennyPals dan tabung uangmu hari ini biar dia senang! 😊"
        content.sound = .default
        content.categoryIdentifier = "DAILY_REMINDER"

        // Trigger setiap hari jam 08:00
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
                print("🔕 Failed to schedule daily reminder: \(error.localizedDescription)")
            } else {
                print("🔔 Daily reminder scheduled for 08:00 every day")
            }
        }
    }

    // MARK: - 2. Penalty Warning

    /// Jadwalkan peringatan penalti berdasarkan nextPenaltyCheck dari UserModel
    func schedulePenaltyWarning(nextPenaltyCheck: Date, petName: String) {
        // Kirim warning 6 jam sebelum penalty
        guard let warningDate = Calendar.current.date(
            byAdding: .hour,
            value: -6,
            to: nextPenaltyCheck
        ) else { return }

        // Jangan schedule jika waktunya sudah lewat
        guard warningDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "⚠️ Penalti Mendekat!"
        content.body = "\(petName) bakal sedih kalau kamu nggak nabung sebelum tengah malam! Yuk buka PennyPals sekarang 💰"
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

        // Hapus warning lama dulu
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [NotificationID.penaltyWarning]
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🔕 Failed to schedule penalty warning: \(error.localizedDescription)")
            } else {
                print("🔔 Penalty warning scheduled for \(warningDate)")
            }
        }
    }

    // MARK: - 3. Pet Hungry Notification

    /// Kirim notifikasi instan bahwa pet lapar
    func sendPetHungryNotification(petName: String) {
        let content = UNMutableNotificationContent()
        content.title = "\(petName) lapar! 🥺"
        content.body = "Hari baru sudah dimulai dan kamu belum menabung. Yuk kasih makan \(petName) dengan menabung sekarang!"
        content.sound = .default
        content.categoryIdentifier = "PET_HUNGRY"

        // Trigger 2 detik dari sekarang (instan)
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

    // MARK: - 4. Streak Celebration

    /// Kirim notifikasi merayakan streak milestone
    func sendStreakCelebration(streak: Int) {
        // Hanya kirim di milestone tertentu
        let milestones = [3, 7, 14, 30, 60, 100, 365]
        guard milestones.contains(streak) else { return }

        let content = UNMutableNotificationContent()
        content.title = "🔥 Streak \(streak) Hari!"

        switch streak {
        case 3:
            content.body = "Wah, kamu sudah nabung 3 hari berturut-turut! Pertahankan ya! 💪"
        case 7:
            content.body = "Satu minggu penuh nabung terus! Pet kamu bangga banget! 🎉"
        case 14:
            content.body = "2 minggu non-stop! Kamu luar biasa konsisten! 🌟"
        case 30:
            content.body = "SEBULAN PENUH! Kamu adalah master penabung sejati! 🏆"
        case 60:
            content.body = "60 hari nabung terus! Pencapaian yang luar biasa! 👑"
        case 100:
            content.body = "100 HARI! Legenda penabung! Pet kamu paling bahagia sedunia! 🎊"
        case 365:
            content.body = "SATU TAHUN PENUH! Kamu benar-benar inspirasi! 🥇🎆"
        default:
            content.body = "Streak-mu terus berlanjut! Hebat! 🔥"
        }

        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "\(NotificationID.streakCelebration).\(streak)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - 5. Level Up Notification

    /// Kirim notifikasi saat pet naik level
    func sendLevelUpNotification(petName: String, newLevel: Int) {
        let content = UNMutableNotificationContent()
        content.title = "⭐ Level Up!"
        content.body = "\(petName) naik ke Level \(newLevel)! Terus nabung biar makin kuat! ✨"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "\(NotificationID.levelUp).\(newLevel)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - 6. Goal Progress Notification

    /// Kirim notifikasi progress goal saat mencapai milestone persentase
    func sendGoalProgressNotification(goalName: String, currentAmount: Double, targetAmount: Double) {
        guard targetAmount > 0 else { return }
        let percentage = Int((currentAmount / targetAmount) * 100)

        // Hanya kirim di milestone 25%, 50%, 75%
        let milestones = [25, 50, 75]
        guard milestones.contains(percentage) else { return }

        let content = UNMutableNotificationContent()
        content.title = "📊 Progress Wishlist!"
        content.body = "Kamu sudah mencapai \(percentage)% dari target \"\(goalName)\"! Ayo terus nabung! 🎯"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "\(NotificationID.goalProgress).\(percentage)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - 7. Goal Completed Notification

    /// Kirim notifikasi saat goal tercapai
    func sendGoalCompletedNotification(goalName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🎉 Wishlist Tercapai!"
        content.body = "Selamat! Kamu berhasil mengumpulkan tabungan untuk \"\(goalName)\"! Waktunya set goal baru! 🎊"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: NotificationID.goalCompleted,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Evening Reminder

    /// Jadwalkan pengingat malam jam 20:00 jika belum menabung hari ini
    func scheduleEveningReminder(petName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🌙 Jangan lupa nabung malam ini!"
        content.body = "\(petName) masih menunggu kamu hari ini. Yuk sempatin nabung sebelum tidur! 💤"
        content.sound = .default
        content.categoryIdentifier = "EVENING_REMINDER"

        // Trigger jam 20:00
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
                print("🔕 Failed to schedule evening reminder: \(error.localizedDescription)")
            } else {
                print("🔔 Evening reminder scheduled for 20:00")
            }
        }
    }

    // MARK: - Cancel Notifications

    /// Batalkan pengingat harian (misalnya saat user sudah nabung hari ini)
    func cancelDailyRemindersForToday() {
        // Hapus pet hungry notification karena sudah nabung
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [NotificationID.petHungry]
        )
        // Hapus juga evening reminder untuk hari ini
        UNUserNotificationCenter.current().removeDeliveredNotifications(
            withIdentifiers: [
                "pennypals.evening.reminder",
                NotificationID.petHungry,
            ]
        )
    }

    /// Batalkan semua pending notifications (misalnya saat logout)
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("🔕 All notifications cancelled")
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Handle notifikasi saat app sedang di foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Tampilkan banner + sound bahkan saat app terbuka
        completionHandler([.banner, .sound])
    }

    /// Handle saat user tap notifikasi
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("🔔 User tapped notification: \(identifier)")
        // App sudah terbuka otomatis oleh iOS saat tap notifikasi
        completionHandler()
    }
}
