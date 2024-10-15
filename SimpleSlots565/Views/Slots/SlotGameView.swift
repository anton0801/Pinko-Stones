import SwiftUI
import SpriteKit

extension Notification.Name {
    static let homeAction = Notification.Name("home_action")
    static let alert = Notification.Name("alert")
}

struct SlotGameView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var slotgameScene: SlotGameScene!
    
    @State var alertVisible = false
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            if let slotgameScene = slotgameScene {
                SpriteView(scene: slotgameScene)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            slotgameScene = SlotGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: .homeAction)) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: .alert)) { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let alertMessage = userInfo["alertMessage"] as? String else { return }
            self.alertMessage = alertMessage
            self.alertVisible = true
        }
        .alert(isPresented: $alertVisible) {
            Alert(title: Text("Alert!"), message: Text(alertMessage))
        }
    }
}

#Preview {
    SlotGameView()
}
