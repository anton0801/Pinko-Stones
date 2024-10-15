import Foundation

class DailyBonusManager: ObservableObject {
    
    @Published var todayBonusAvailable: Bool = UserDefaults.standard.bool(forKey: "bonus_used_today")
    @Published var welcomeBonusClaimed: Bool = UserDefaults.standard.bool(forKey: "welcome_bonus_claimed")
    
    func bonusUsedToday() {
        todayBonusAvailable = true
    }
    
    func claimWelcomeBonus() {
        welcomeBonusClaimed = true
    }
    
}
