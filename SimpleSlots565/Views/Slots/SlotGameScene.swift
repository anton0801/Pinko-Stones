import SpriteKit
import SwiftUI

class SlotGameScene: SKScene {
    
    private var barabanOfSlotitem1: BarabanOfSlotItemNode!
    private var barabanOfSlotitem2: BarabanOfSlotItemNode!
    private var barabanOfSlotitem3: BarabanOfSlotItemNode!
    private var barabanOfSlotitem4: BarabanOfSlotItemNode!
    
    private var homeButton: SKSpriteNode!
    private var spinBtn: SKSpriteNode!
    private var betPlus: SKSpriteNode!
    private var betMinus: SKSpriteNode!
    
    private var bet = 100 {
        didSet {
            betlabel.text = "\(bet)"
        }
    }
    private var betlabel: SKLabelNode!
    
    private var balance = UserDefaults.standard.integer(forKey: "user_credits") {
        didSet {
            balanceLabel.text = "\(balance)"
            UserDefaults.standard.set(balance, forKey: "user_credits")
        }
    }
    private var balanceLabel: SKLabelNode!
    
    private var currentWin: Int = 0 {
        didSet {
            currentWinLabel.text = "WIN: \(currentWin)"
        }
    }
    private var currentWinLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1100, height: 2300)
        
        createAllUI()
    }
    
    private func createAllUI() {
        createBackground()
        createAllBtns()
        createSlotItem()
    }
    
    private func createAllBtns() {
        homeButton = SKSpriteNode(imageNamed: "home")
        homeButton.position = CGPoint(x: 150, y: size.height - 130)
        homeButton.size = CGSize(width: 150, height: 150)
        addChild(homeButton)
        
        spinBtn = SKSpriteNode(imageNamed: "spin")
        spinBtn.position = CGPoint(x: size.width - 250, y: 150)
        spinBtn.size = CGSize(width: 350, height: 140)
        addChild(spinBtn)
        
        let betPlacementBackground = SKSpriteNode(imageNamed: "bet_label")
        betPlacementBackground.position = CGPoint(x: 250, y: 200)
        betPlacementBackground.size = CGSize(width: 400, height: 300)
        addChild(betPlacementBackground)
        
        betlabel = SKLabelNode(text: "\(bet)")
        betlabel.fontName = "PragmaticaExt-ExtraBold"
        betlabel.fontSize = 62
        betlabel.fontColor = UIColor.init(red: 239/255, green: 209/255, blue: 115/255, alpha: 1)
        betlabel.position = CGPoint(x: 170, y: 230)
        addChild(betlabel)
        
        betPlus = SKSpriteNode(imageNamed: "plus")
        betPlus.position = CGPoint(x: 370, y: 260)
        betPlus.size = CGSize(width: 120, height: 110)
        addChild(betPlus)
        
        betMinus = SKSpriteNode(imageNamed: "minus")
        betMinus.position = CGPoint(x: 370, y: 130)
        betMinus.size = CGSize(width: 120, height: 110)
        addChild(betMinus)
        
        balanceLabel = SKLabelNode(text: "\(balance)")
        balanceLabel.fontName = "PragmaticaExt-ExtraBold"
        balanceLabel.fontSize = 62
        balanceLabel.fontColor = UIColor.init(red: 239/255, green: 209/255, blue: 115/255, alpha: 1)
        balanceLabel.position = CGPoint(x: size.width - 150, y: size.height - 160)
        addChild(balanceLabel)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: balanceLabel.position.x - 150, y: balanceLabel.position.y + 25)
        coinImage.size = CGSize(width: 100, height: 100)
        addChild(coinImage)
        
        currentWinLabel = SKLabelNode(text: "WIN: \(currentWin)")
        currentWinLabel.fontName = "PragmaticaExt-ExtraBold"
        currentWinLabel.fontSize = 62
        currentWinLabel.fontColor = .white
        currentWinLabel.position = CGPoint(x: size.width / 2, y: size.height - 400)
        addChild(currentWinLabel)
    }
    
    private func createBackground() {
        let backgroundSlots = SKSpriteNode(imageNamed: "game_background")
        backgroundSlots.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundSlots.size = size
        backgroundSlots.zPosition = -1
        addChild(backgroundSlots)
    }
    
    private func createSlotItem() {
        barabanOfSlotitem1 = BarabanOfSlotItemNode(symbolIds: (1...6).map { "item\($0)" }, size: CGSize(width: 200, height: 1250))
        barabanOfSlotitem1.position = CGPoint(x: 170, y: size.height / 2)
        addChild(barabanOfSlotitem1)
        
        barabanOfSlotitem2 = BarabanOfSlotItemNode(symbolIds: (1...6).map { "item\($0)" }, size: CGSize(width: 200, height: 1250))
        barabanOfSlotitem2.position = CGPoint(x: 420, y: size.height / 2)
        addChild(barabanOfSlotitem2)
        
        barabanOfSlotitem3 = BarabanOfSlotItemNode(symbolIds: (1...6).map { "item\($0)" }, size: CGSize(width: 200, height: 1250))
        barabanOfSlotitem3.position = CGPoint(x: 670, y: size.height / 2)
        addChild(barabanOfSlotitem3)
        
        barabanOfSlotitem4 = BarabanOfSlotItemNode(symbolIds: (1...6).map { "item\($0)" }, size: CGSize(width: 200, height: 1250))
        barabanOfSlotitem4.position = CGPoint(x: 920, y: size.height / 2)
        addChild(barabanOfSlotitem4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let nodesAtPoint = nodes(at: touch.location(in: self))
            
            for object in nodesAtPoint {
                if object == spinBtn {
                    spin()
                    return
                } else if object == betPlus {
                    bet += 100
                    return
                } else if object == betMinus {
                    if bet > 100 {
                        bet -= 100
                    }
                    return
                } else if object == homeButton {
                    NotificationCenter.default.post(name: Notification.Name("home_action"), object: nil)
                }
            }
        }
    }
    
    private func spin() {
        if balance >= bet {
            barabanOfSlotitem1.startSpinningBaraban()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.barabanOfSlotitem2.startSpinningBaraban()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.barabanOfSlotitem3.startSpinningBaraban()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.barabanOfSlotitem4.startSpinningBaraban()
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("alert"), object: nil, userInfo: ["alertMessage": "Your bet exceeds your balance! Reduce your bet to continue playing!"])
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: SlotGameScene())
            .ignoresSafeArea()
    }
}
