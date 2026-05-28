//
//  OnboardingViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//
import Testing

@testable import PennyPals

struct OnboardingViewModelTests {

    @Test("Pembuatan Goal Awal (Wishlist) dari Setup Tabungan")
    func testInitialGoalCreation() {
        let initialSavings: Double = 500000

        let initialGoal = GoalModel(
            userId: "user_123",
            itemName: "My First Goal",
            targetAmount: 5_000_000,
            currentAmount: initialSavings,
            isCompleted: false
        )

        #expect(
            initialGoal.currentAmount == 500000,
            "Tabungan awal harus tercatat akurat"
        )
        #expect(
            initialGoal.targetAmount == 5_000_000,
            "Target default adalah 5 juta"
        )
        #expect(
            initialGoal.isCompleted == false,
            "Goal tidak boleh langsung selesai"
        )
    }

    @Test("Status Selesai (Completed) Saat Tabungan Memenuhi Target")
    func testGoalCompletionLogic() {
        var goal = GoalModel(
            userId: "user_123",
            itemName: "AirPods",
            targetAmount: 2_000_000,
            currentAmount: 1_800_000,
            isCompleted: false
        )

        // Simulasi input manual menabung Rp 200.000
        let addedSavings: Double = 200000
        goal.currentAmount += addedSavings

        if goal.currentAmount >= goal.targetAmount {
            goal.isCompleted = true
        }

        #expect(
            goal.isCompleted == true,
            "Status goal harus berubah menjadi selesai (true)"
        )
    }
}
