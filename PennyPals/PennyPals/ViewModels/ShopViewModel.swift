//
//  ShopViewModel.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

internal import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

/// ViewModel yang mengelola seluruh data berkaitan dengan toko (Shop) dan inventori aset virtual pengguna.
/// Bertanggung jawab untuk mengambil daftar item yang dijual, memproses transaksi pembelian,
/// serta mengelola item yang digunakan (Equipped) seperti latar belakang dan aksesoris.
@MainActor
class ShopViewModel: ObservableObject {

    /// Daftar lengkap item yang tersedia di toko, baik aksesoris maupun background.
    @Published var shopItems: [ShopItemModel] = []

    /// Kumpulan ID dari semua aset virtual yang telah berhasil dibeli dan dimiliki oleh pengguna.
    @Published var unlockedItemIds: [String] = []

    /// Pesan error lokal yang muncul jika ada kendala saat proses transaksi atau pengambilan data.
    @Published var errorMessage: String?

    /// ID dokumen dari item latar belakang (Background) yang saat ini sedang aktif digunakan.
    @Published var selectedBackgroundId: String?

    /// ID dokumen dari item aksesoris (Accessory) yang saat ini sedang aktif digunakan.
    @Published var selectedAccessoryId: String?

    private var db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    init() {
        fetchShopItems()
        fetchUserInventory()

        // Listener untuk menerima instruksi penggantian background langsung dari perangkat Apple Watch
        NotificationCenter.default.addObserver(
            forName: .watchRequestedEquipBackground,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let id = notification.userInfo?["id"] as? String {
                self?.useBackground(id: id)
            }
        }
    }

    /// Mengambil seluruh data katalog item toko dari database Firebase secara real-time.
    /// Jika terjadi kesalahan jaringan atau koleksi kosong, aplikasi akan menyajikan item bawaan (fallback).
    func fetchShopItems() {
        let defaultItems = [
            ShopItemModel(
                id: "acc_hat",
                name: "Cute Hat",
                category: "Accessories",
                price: 150,
                colorHex: nil,
                spotsHex: nil,
                imageName: "tshirt.fill",
                isGradient: false,
                endColorHex: nil
            )
        ]

        db.collection("shopItems").addSnapshotListener {
            [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print(
                    "❌ Error fetching shop items: \(error.localizedDescription)"
                )
                self.shopItems = defaultItems
                return
            }

            guard let docs = snapshot?.documents, !docs.isEmpty else {
                print("⚠️ Collection shopItems kosong di Firebase!")
                self.shopItems = defaultItems
                return
            }

            var fetchedItems: [ShopItemModel] = []

            for doc in docs {
                do {
                    let item = try doc.data(as: ShopItemModel.self)
                    fetchedItems.append(item)
                } catch {
                    print(
                        "❌ Error Decoding Item di Firebase (ID: \(doc.documentID)): \(error)"
                    )
                }
            }

            var finalItems = fetchedItems
            for dItem in defaultItems {
                if !finalItems.contains(where: { $0.id == dItem.id }) {
                    finalItems.append(dItem)
                }
            }

            self.shopItems = finalItems
        }
    }

    /// Memantau data inventori spesifik milik pengguna secara real-time dan melakukan sinkronisasi dengan WatchOS.
    func fetchUserInventory() {
        guard let uid = userId else { return }
        db.collection("inventories").document(uid).addSnapshotListener {
            snapshot,
            _ in
            let inv = try? snapshot?.data(as: UserInventoryModel.self)
            self.unlockedItemIds = inv?.unlockedItemIds ?? []
            self.selectedBackgroundId = inv?.selectedBackgroundId
            self.selectedAccessoryId = inv?.selectedAccessoryId

            // Melakukan forward data aset background yang dimiliki ke watchOS extension
            let ownedBgs = self.shopItems
                .filter {
                    $0.category == "Backgrounds"
                        && self.unlockedItemIds.contains($0.id ?? "")
                }
                .map { item -> [String: String] in
                    [
                        "id": item.id ?? "",
                        "name": item.name,
                        "colorHex": item.colorHex ?? "#1A1A2E",
                        "spotsHex": item.spotsHex ?? "#16213E",
                        "isGradient": String(item.isGradient ?? false),
                        "endColorHex": item.endColorHex ?? item.colorHex ?? "",
                    ]
                }
            PhoneConnectivity.shared.sendInventoryToWatch(
                ownedBackgrounds: ownedBgs,
                selectedBackgroundId: self.selectedBackgroundId
            )
        }
    }

    /// Memproses logika transaksional untuk pembelian item toko baru menggunakan koin virtual pengguna.
    /// - Parameters:
    ///   - item: Entitas produk (ShopItemModel) yang akan dibeli.
    ///   - currentUserCoins: Jumlah saldo koin terkini milik pengguna.
    func purchaseItem(item: ShopItemModel, currentUserCoins: Int) {
        guard let uid = userId, let itemId = item.id else { return }

        if unlockedItemIds.contains(itemId) {
            self.errorMessage = "Item sudah dimiliki!"
            return
        }

        if currentUserCoins < item.price {
            self.errorMessage = "Koin tidak cukup!"
            return
        }

        let batch = db.batch()

        // Mengurangi saldo koin pengguna di dokumen "users"
        let userRef = db.collection("users").document(uid)
        batch.updateData(
            ["coins": currentUserCoins - item.price],
            forDocument: userRef
        )

        // Menambahkan item ke dokumen "inventories" pengguna
        let inventoryRef = db.collection("inventories").document(uid)
        var data: [String: Any] = [
            "userId": uid,
            "unlockedItemIds": FieldValue.arrayUnion([itemId]),
        ]

        if item.category == "Backgrounds" {
            data["selectedBackgroundId"] = itemId
        }

        batch.setData(data, forDocument: inventoryRef, merge: true)

        batch.commit { error in
            if let err = error {
                self.errorMessage = err.localizedDescription
            } else {
                // Memberikan reaksi visual berupa perubahan mood "wink" pada peliharaan setelah transaksi berhasil
                self.db.collection("pets").whereField("userId", isEqualTo: uid)
                    .getDocuments { snap, _ in
                        if let petDoc = snap?.documents.first {
                            petDoc.reference.updateData(["mood": "wink"])
                        }
                    }
            }
        }
    }

    /// Menerapkan (equip) item Background spesifik yang dipilih oleh pengguna menggunakan objek modelnya.
    /// - Parameter item: Objek `ShopItemModel` dengan kategori Background.
    func useBackground(item: ShopItemModel) {
        guard let uid = userId, let itemId = item.id else { return }

        guard unlockedItemIds.contains(itemId) else {
            self.errorMessage = "Beli dulu background-nya!"
            return
        }

        db.collection("inventories").document(uid).setData(
            ["selectedBackgroundId": itemId],
            merge: true
        )
    }

    /// Menerapkan (equip) item Background yang dipilih menggunakan referensi ID-nya.
    /// - Parameter id: ID unik tipe string yang merepresentasikan background.
    func useBackground(id: String) {
        guard let uid = userId else { return }

        guard unlockedItemIds.contains(id) else {
            self.errorMessage = "Beli dulu background-nya!"
            return
        }

        db.collection("inventories").document(uid).setData(
            ["selectedBackgroundId": id],
            merge: true
        )
    }

    /// Mengubah / beralih status penerapan (Equip atau Unequip) dari sebuah aset item kosmetik berdasarkan kondisinya saat ini.
    /// - Parameter item: Objek `ShopItemModel` yang akan di-toggle status pemakaiannya.
    func toggleEquipItem(item: ShopItemModel) {
        guard let uid = userId, let itemId = item.id else { return }

        guard unlockedItemIds.contains(itemId) else {
            self.errorMessage = "Beli dulu item-nya!"
            return
        }

        var updateData: [String: Any] = [:]

        if item.category == "Backgrounds" {
            let isCurrentlyEquipped = (self.selectedBackgroundId == itemId)
            updateData["selectedBackgroundId"] =
                isCurrentlyEquipped ? FieldValue.delete() : itemId
        } else if item.category == "Accessories" {
            let isCurrentlyEquipped = (self.selectedAccessoryId == itemId)
            updateData["selectedAccessoryId"] =
                isCurrentlyEquipped ? FieldValue.delete() : itemId
        }

        db.collection("inventories").document(uid).setData(
            updateData,
            merge: true
        ) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
