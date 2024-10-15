import Foundation

class DailyBonusManager: ObservableObject {
    
    @Published var todayBonusAvailable: Bool = UserDefaults.standard.bool(forKey: "bonus_used_today") {
        didSet {
            UserDefaults.standard.set(todayBonusAvailable, forKey: "bonus_used_today")
        }
    }
    @Published var welcomeBonusClaimed: Bool = UserDefaults.standard.bool(forKey: "welcome_bonus_claimed") {
        didSet {
            UserDefaults.standard.set(welcomeBonusClaimed, forKey: "welcome_bonus_claimed")
        }
    }
    
    init() {
        if !todayBonusAvailable && !UserDefaults.standard.bool(forKey: "is_not_set_true") {
            todayBonusAvailable = true
            UserDefaults.standard.set(true, forKey: "is_not_set_true")
        }
    }
    
    func bonusUsedToday() {
        todayBonusAvailable = false
    }
    
    func claimWelcomeBonus() {
        welcomeBonusClaimed = true
    }
    
}
