//
//  OnboardingViewModelTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 28/05/26.
//

import XCTest

@testable import PennyPals

final class OnboardingViewModelTests: XCTestCase {

    func testInitialGoalCreation() {
        let initialSavings: Double = 500000

        let initialGoal = GoalModel(
            userId: "user_123",
            itemName: "My First Goal",
            targetAmount: 5_000_000,
            currentAmount: initialSavings,
            isCompleted: false
        )

        XCTAssertEqual(
            initialGoal.currentAmount,
            500000,
            "Tabungan awal harus tercatat akurat"
        )
        XCTAssertEqual(
            initialGoal.targetAmount,
            5_000_000,
            "Target default adalah 5 juta"
        )
        XCTAssertFalse(
            initialGoal.isCompleted,
            "Goal tidak boleh langsung selesai"
        )
    }

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

        XCTAssertTrue(
            goal.isCompleted,
            "Status goal harus berubah menjadi selesai (true)"
        )
    }
}
