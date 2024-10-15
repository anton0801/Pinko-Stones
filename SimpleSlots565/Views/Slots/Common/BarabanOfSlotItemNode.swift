import Foundation
import SpriteKit

class BarabanOfSlotItemNode: SKSpriteNode {
    
    var reversedSpinState = false
    
    init(symbolIds: [String], size: CGSize) {
        self.symbolIds = symbolIds
        self.endspincallback = nil
        super.init(texture: nil, color: .clear, size: size)
        createBackgroundForSymbols()
        setUpSymbolsAndInitializeNodes()
    }
    
    init(symbolIds: [String], size: CGSize, endspincallback: (() -> Void)?) {
        self.symbolIds = symbolIds
        self.endspincallback = endspincallback
        super.init(texture: nil, color: .clear, size: size)
        createBackgroundForSymbols()
        setUpSymbolsAndInitializeNodes()
    }
    
    
    private func reversedScroll() {
        reversedSpinState = false
        let actionMove = SKAction.moveBy(x: 0, y: -(217.5 * CGFloat(Int.random(in: 4...6))), duration: 0.3)
        slotItemContent.run(actionMove) {
            self.endspincallback?()
        }
    }
    var endspincallback: (() -> Void)?
    
    private func createBackgroundForSymbols() {
        let backgroundItemTexture = SKTexture(imageNamed: "slot_item_background")
        let symbol1Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol1Back.position = CGPoint(x: 0, y: size.height / 2 - 65)
        symbol1Back.size = CGSize(width: 220, height: 190)
        addChild(symbol1Back)
        
        let symbol2Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol2Back.position = CGPoint(x: 0, y: size.height / 2 - (65 + (217.5 * 1)))
        symbol2Back.size = CGSize(width: 220, height: 190)
        addChild(symbol2Back)
        
        let symbol3Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol3Back.position = CGPoint(x: 0, y: size.height / 2 - (65 + (217.5 * 2)))
        symbol3Back.size = CGSize(width: 220, height: 190)
        addChild(symbol3Back)
        
        let symbol4Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol4Back.position = CGPoint(x: 0, y: size.height / 2 - (65 + (217.5 * 3)))
        symbol4Back.size = CGSize(width: 220, height: 190)
        addChild(symbol4Back)
        
        let symbol5Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol5Back.position = CGPoint(x: 0, y: size.height / 2 - (65 + (217.5 * 4)))
        symbol5Back.size = CGSize(width: 220, height: 190)
        addChild(symbol5Back)
        
        let symbol6Back = SKSpriteNode(texture: backgroundItemTexture)
        symbol6Back.position = CGPoint(x: 0, y: size.height / 2 - (65 + (217.5 * 5)))
        symbol6Back.size = CGSize(width: 220, height: 190)
        addChild(symbol6Back)
    }
    
    func startSpinningBaraban() {
        if reversedSpinState {
            reversedScroll()
        } else {
            unreversedScroll()
        }
    }
    
    private func unreversedScroll() {
        let actionMove = SKAction.moveBy(x: 0, y: 217.5 * CGFloat(Int.random(in: 4...6)), duration: 0.3)
        slotItemContent.run(actionMove) {
            self.endspincallback?()
        }
        reversedSpinState = true
    }
    private var slotItemContent: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cropepSlotItemNode: SKCropNode!
    
    private func setUpSymbolsAndInitializeNodes() {
        self.cropepSlotItemNode = SKCropNode()
        self.slotItemContent = SKNode()
        
        cropepSlotItemNode.position = CGPoint(x: 0, y: 0)
        let maskedNodeWithOutOtherUnusedSymbols = SKSpriteNode(color: .black, size: size)
        maskedNodeWithOutOtherUnusedSymbols.position = CGPoint(x: 0, y: 0)
        cropepSlotItemNode.maskNode = maskedNodeWithOutOtherUnusedSymbols
        addChild(cropepSlotItemNode)
        cropepSlotItemNode.addChild(slotItemContent)

        let symbolsRangedAndShuffled = symbolIds.shuffled()
        
        for i in 0..<symbolIds.count * 8 {
            let nodeSymbols = SKSpriteNode(imageNamed: symbolsRangedAndShuffled[i % symbolIds.count])
            nodeSymbols.size = CGSize(width: 160, height: 160)
            nodeSymbols.name = symbolsRangedAndShuffled[i % symbolIds.count]
            nodeSymbols.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 217.5)
            nodeSymbols.zPosition = 1
            slotItemContent.addChild(nodeSymbols)
        }
        
        slotItemContent.run(SKAction.moveBy(x: 0, y: 215.5 * CGFloat(symbolIds.count * 3), duration: 0.0))
    }
    
    var symbolIds: [String]
    
    
}
