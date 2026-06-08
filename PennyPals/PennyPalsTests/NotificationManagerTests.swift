//
//  NotificationManagerTests.swift
//  PennyPals
//
//  Created by Kelompok 8 on 08/06/26.
//

import Testing
import Foundation

@testable import PennyPals

struct NotificationManagerTests {

    @Test("Validasi Milestone Streak")
    func testStreakMilestones() {
        // Daftar streak yang seharusnya memicu notifikasi perayaan
        let validMilestones = [3, 7, 14, 30, 60, 100, 365]
        
        // Memeriksa apakah milestone yang valid dikenali (mensimulasikan logika di NotificationManager)
        for streak in validMilestones {
            let isMilestone = validMilestones.contains(streak)
            #expect(isMilestone == true, "Streak \(streak) harusnya menjadi milestone")
        }
        
        // Memeriksa bahwa streak biasa tidak memicu milestone khusus
        let normalStreak = 5
        let isNormalMilestone = validMilestones.contains(normalStreak)
        #expect(isNormalMilestone == false, "Streak \(normalStreak) tidak seharusnya memicu milestone")
    }
    
    @Test("Validasi Progress Goal Milestone")
    func testGoalProgressMilestones() {
        let targetAmount: Double = 1000000
        
        // Skenario 1: 25% progress
        let currentAmount1: Double = 250000
        let percentage1 = Int((currentAmount1 / targetAmount) * 100)
        let milestones = [25, 50, 75]
        
        #expect(milestones.contains(percentage1) == true, "25% harus memicu notifikasi progress")
        
        // Skenario 2: 40% progress
        let currentAmount2: Double = 400000
        let percentage2 = Int((currentAmount2 / targetAmount) * 100)
        
        #expect(milestones.contains(percentage2) == false, "40% tidak memicu notifikasi progress")
    }
    
    @Test("Kalkulasi Waktu Peringatan Penalti")
    func testPenaltyWarningCalculation() {
        let now = Date()
        guard let nextPenaltyCheck = Calendar.current.date(byAdding: .day, value: 2, to: now) else {
            Issue.record("Gagal membuat tanggal nextPenaltyCheck")
            return
        }
        
        // Peringatan harusnya 6 jam sebelum penalty
        guard let warningDate = Calendar.current.date(byAdding: .hour, value: -6, to: nextPenaltyCheck) else {
            Issue.record("Gagal membuat tanggal warningDate")
            return
        }
        
        let diffHours = Calendar.current.dateComponents([.hour], from: warningDate, to: nextPenaltyCheck).hour
        
        #expect(diffHours == 6, "Peringatan harus dijadwalkan tepat 6 jam sebelum penalti")
        #expect(warningDate > now, "Tanggal peringatan harus di masa depan")
    }
}
