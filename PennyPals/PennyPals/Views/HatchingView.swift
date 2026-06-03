//
//  HatchingView.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import SwiftUI

/// `HatchingView` adalah komponen antarmuka (UI) yang menampilkan sekuens animasi menetasnya telur.
/// View ini dirancang menggunakan sistem animasi berbasis frame (spritesheet mekanik lokal)
/// yang berjalan selaras dengan peningkatan indikator progress bar.
///
/// ### Cara Penggunaan:
/// ```swift
/// HatchingView(eggId: "rose") {
///     print("Proses menetas selesai!")
/// }
/// ```
struct HatchingView: View {

    // MARK: - Passthrough Parameters

    /// Identifier unik jenis telur yang dipilih oleh pengguna saat onboarding (contoh: "rose", "mint", "sky").
    var eggId: String

    /// Callback closure yang dipanggil secara otomatis sesaat setelah progress mencapai 100% dan animasi selesai.
    var onComplete: () -> Void

    // MARK: - State Properties

    /// Menyimpan nilai progress menetas saat ini dengan rentang nilai antara `0.0` (mulai) hingga `1.0` (selesai).
    @State private var progress: Double = 0.0

    /// State flag untuk mengontrol status animasi loncat (*bouncing effect*) pada aset visual telur.
    @State private var isBouncing = false

    /// Timer internal yang memicu pembaruan frame visual dan progress bar setiap 0.1 detik di *Main Thread*.
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // MARK: - Computed Properties

    /// Menghitung indeks gambar frame aktif (1 sampai 7) berdasarkan progress menetas saat ini.
    /// Indeks ini digunakan untuk mensimulasikan animasi keretakan telur secara bertahap.
    ///
    /// - Returns: Nilai `Int` antara 1 hingga 7.
    private var currentFrameIndex: Int {
        let maxFrames = 7
        // Mengonversi nilai progress (0.0 - 1.0) menjadi indeks integer (1 - 7)
        var index = Int(progress * Double(maxFrames)) + 1

        // Pencegahan overflow (defensive programming) agar indeks tidak melebihi total frame maksimal
        if index > maxFrames {
            index = maxFrames
        }
        return index
    }

    /// Menghasilkan nama aset gambar lengkap (*Asset Name*) yang sesuai di Xcode Assets Catalog.
    /// Nama ini dibentuk dengan memetakan `eggId` ke nama dasar berkas lalu menggabungkannya dengan indeks frame 2-digit.
    ///
    /// Contoh Output: Jika `eggId` adalah `"rose"` dan `progress` di awal, akan menghasilkan `"PinkEgg01"`.
    ///
    /// - Returns: `String` nama aset gambar yang valid.
    private var currentImageName: String {
        let baseName: String

        // Pemetaan ID Telur ke Nama Dasar File Gambar di Assets
        switch eggId {
        case "rose": baseName = "PinkEgg"
        case "mint": baseName = "GreenEgg"
        case "sky": baseName = "BlueEgg"
        case "sun": baseName = "YellowEgg"
        case "lilac": baseName = "PurpleEgg"
        case "peach": baseName = "PeachEgg"
        default: baseName = "BlueEgg"  // Fallback aman jika ID tidak terdaftar
        }

        // Memformat penomoran frame menjadi 2 digit string (contoh: 1 -> "01", 7 -> "07")
        let frameString = String(format: "%02d", currentFrameIndex)
        return "\(baseName)\(frameString)"
    }

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // MARK: Egg Graphic Section
            ZStack {
                // Merender gambar telur secara dinamis berdasarkan frame keretakan saat ini
                Image(currentImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .offset(y: isBouncing ? -10 : 10)  // Memberikan efek pergerakan vertikal (loncat)
            }
            .frame(height: 150)
            .onAppear {
                // Memicu animasi bouncing secara linear-looping saat halaman dimuat
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) {
                    isBouncing = true
                }
            }

            // MARK: Progress & Typography Section
            VStack(spacing: 16) {
                Text("Hatching...")
                    .font(.headline)
                    .foregroundColor(.pennyText)

                // Custom Progress Bar dengan desain kapsul minimalis
                ZStack(alignment: .leading) {
                    // Track Background Batang Progress
                    Capsule()
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(height: 12)

                    // Batang Indikator Isi (Mengisi sesuai dengan variabel progress)
                    Capsule()
                        .fill(Color.hatchingBarGradient)
                        .frame(width: progress * 300, height: 12)
                        .animation(.linear(duration: 0.1), value: progress)
                }
                .frame(width: 300)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pennyBackground.ignoresSafeArea())

        // MARK: - Timer Receiver Logic
        .onReceive(timer) { _ in
            if progress < 1.0 {
                // Menambahkan progress sebesar 2% setiap tick (0.1 detik) -> Estimasi total waktu 5 detik
                progress += 0.02
            } else {
                // Menghentikan / mematikan timer (invalidate upstream connection) saat progress mencapai 100%
                timer.upstream.connect().cancel()

                // Memberikan jeda waktu kosmetik 0.5 detik agar pengguna sempat melihat telur retak sepenuhnya
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()  // Eksekusi aksi penutupan atau navigasi ke halaman Pet baru
                }
            }
        }
    }
}
