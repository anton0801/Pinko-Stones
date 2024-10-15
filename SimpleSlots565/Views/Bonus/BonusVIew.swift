import SwiftUI

struct BonusVIew: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var dailyBonusManager: DailyBonusManager
    
    @State var balance = UserDefaults.standard.integer(forKey: "user_credits")
    @State private var rotationAngle: Double = 0
    @State private var isSpinning: Bool = false
    @State private var selectedPrize: String = "Spin to Win!"

    let segments = ["JACKPOT", "100", "LOSE", "500", "200", "1000", "100", "LOSE", "500", "200"]
    let initialAngle: Double = 0
     
    @State var freeSpinsLeft = UserDefaults.standard.integer(forKey: "free_spins_left")
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 82, height: 82)
                }
                Spacer()
                
                Image("coin")
                Text("\(balance)")
                    .font(.custom("PragmaticaExt-ExtraBold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init(red: 239/255, green: 209/255, blue: 115/255))
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: -1)
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: 1)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("\(selectedPrize)")
                .font(.custom("PragmaticaExt-ExtraBold", size: 32))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: -1)
                .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: 1)
            
            ZStack {
                Image("roulette")
                    .resizable()
                    .frame(width: 350, height: 350)
                    .rotationEffect(Angle(degrees: rotationAngle))
                    .animation(.easeInOut(duration: 4), value: rotationAngle)
                Image("roulette_indicator")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .offset(y: -160)
            }
            .padding(.top)
            
            Spacer()
            
            HStack {
                Text("FREE SPINS:")
                    .font(.custom("PragmaticaExt-ExtraBold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: -1)
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: 1)
                Text("\(freeSpinsLeft)")
                    .font(.custom("PragmaticaExt-ExtraBold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: -1)
                    .shadow(color: Color.init(red: 197/255, green: 173/255, blue: 106/255), radius: 2, x: 1)
                Spacer()
                Button {
                    spinRoulette()
                } label: {
                    Image("spin")
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: freeSpinsLeft) { newValue in
            UserDefaults.standard.set(newValue, forKey: "free_spins_left")
            if newValue == 0 {
                dailyBonusManager.todayBonusAvailable = false
                presMode.wrappedValue.dismiss()
            }
        }
        .background(
            Image("bonus_back")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    // Метод для запуска вращения рулетки
    func spinRoulette() {
        selectedPrize = "Spinning..."
        isSpinning = true
        let randomSpin = Double.random(in: 720...1080) // Случайное количество оборотов (2-3 оборота)
        let finalAngle = randomSpin + determineWinningAngle()
        
        withAnimation(Animation.easeOut(duration: 4)) {
            rotationAngle += finalAngle // Вращаем рулетку
        }
        
        // Вычисляем победный сегмент после окончания анимации
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let segmentIndex = determineWinningSegment(rotationAngle: rotationAngle)
            selectedPrize = segments[segmentIndex]
            if selectedPrize != "LOSE" {
                if selectedPrize == "JACKPOT" {
                    balance += 5000
                } else {
                    balance += Int(selectedPrize) ?? 0
                }
            }
            isSpinning = false
        }
    }
    
    // Вычисляем угол, который соответствует победному сегменту
    func determineWinningAngle() -> Double {
        let segmentIndex = Int.random(in: 0..<segments.count) // Случайный сегмент
        let anglePerSegment = 360.0 / Double(segments.count)
        return Double(segmentIndex) * anglePerSegment
    }
    
    // Определяем индекс победного сегмента по углу вращения
    func determineWinningSegment(rotationAngle: Double) -> Int {
        // Учитываем начальный угол, с которого начинается рулетка
        let normalizedAngle = (rotationAngle + initialAngle).truncatingRemainder(dividingBy: 360)
        let anglePerSegment = 360.0 / Double(segments.count)
        
        // Корректируем на смещение угла, чтобы начать с правильного сегмента
        var segmentIndex = Int((normalizedAngle + anglePerSegment / 2) / anglePerSegment) % segments.count
        
        if segmentIndex < 0 {
            segmentIndex += segments.count
        }
        
        return segmentIndex
    }
    
}

#Preview {
    BonusVIew()
}
