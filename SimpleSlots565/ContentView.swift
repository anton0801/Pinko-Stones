import SwiftUI

struct ContentView: View {
    
    @State var soundState = UserDefaults.standard.bool(forKey: "sound_state_value")
    @StateObject var dailyBonusManager = DailyBonusManager()
    
    @State var alertVisible = false
    @State var alertMessage = ""
    
    @State var goToWelcomeBonus = false
    @State var goToBonus = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        soundState.toggle()
                    } label: {
                        Image("sound_btn")
                            .resizable()
                            .frame(width: 82, height: 82)
                            .opacity(soundState ? 1 : 0.6)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: SlotGameView()
                    .navigationBarBackButtonHidden()) {
                    Image("play")
                }
                
                Button {
                    if !dailyBonusManager.welcomeBonusClaimed {
                        goToWelcomeBonus = true
                        return
                    }
                    print("")
                    
                    if dailyBonusManager.todayBonusAvailable {
                        goToBonus = true
                    } else {
                        alertMessage = "You have used the bonus today! The next bonus will be available in 24 hours"
                        alertVisible = true
                    }
                } label: {
                    Image("bonus")
                }
                .padding(.top)
                
                Button {
                    exit(0)
                } label: {
                    Image("exit")
                }
                .padding(.top)
                
                NavigationLink(destination: WelcomeBonusView()
                    .environmentObject(dailyBonusManager)
                    .navigationBarBackButtonHidden(), isActive: $goToWelcomeBonus) {
                    
                }
                
                NavigationLink(destination: BonusVIew()
                    .environmentObject(dailyBonusManager)
                    .navigationBarBackButtonHidden(), isActive: $goToBonus) {
                    
                }
            }
            .alert(isPresented: $alertVisible, content: {
                Alert(title: Text("Alert!"), message: Text(alertMessage))
            })
            .onAppear {
                if dailyBonusManager.todayBonusAvailable {
                    UserDefaults.standard.set(10, forKey: "free_spins_left")
                }
            }
            .background(
                Image("menu_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
