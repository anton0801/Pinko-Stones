import SwiftUI

struct WelcomeBonusView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var dailyBonusManager: DailyBonusManager
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dailyBonusManager.welcomeBonusClaimed = true
                    UserDefaults.standard.set(10000, forKey: "user_credits")
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 82, height: 82)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                    .fill(.black.opacity(0.6))
                    .frame(width: 300, height: 300)
                
                VStack {
                    Text("WELCOME\nBONUS")
                        .font(.custom("PragmaticaExt-ExtraBold", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(red: 255/255, green: 13/255, blue: 17/255), radius: 2, x: -1)
                        .shadow(color: Color.init(red: 255/255, green: 13/255, blue: 17/255), radius: 2, x: 1)
                    
                    Image("bonus_10000")
                        .resizable()
                        .frame(width: 220, height: 80)
                        .offset(y: -15)
                    
                    Button {
                        dailyBonusManager.welcomeBonusClaimed = true
                        UserDefaults.standard.set(10000, forKey: "user_credits")
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("take")
                            .resizable()
                            .frame(width: 150, height: 50)
                    }
                }
            }
            .frame(width: 300, height: 300)
            .background(
                RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
        }
        .background(
            Image("welcome_bonus_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    WelcomeBonusView()
        .environmentObject(DailyBonusManager())
}
