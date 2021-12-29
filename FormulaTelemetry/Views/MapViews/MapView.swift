//
//  MapView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/9/21.
//

import Foundation
import SwiftUI
import F12020TelemetryPackets

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)

        
        let size = CGSize(width: 40, height: 40)
        let cube = SKShapeNode(rectOf: size)
        cube.fillColor = .red
        //cube.physicsBody = SKPhysicsBody(rectangleOf: size)
        cube.position = CGPoint(x: 50, y: 50)
        //cube.position = location

        addChild(cube)
    }
    
    func draw(x: Float, y: Float) {
        let point = CGPoint(x: Int(x), y: Int(y))
        let from = self.convertPoint(fromView: point)
        let to = self.convertPoint(toView: point)
        
        print("orig: \(point)")
        print("from: \(from)")
        print("to: \(to)")
        
        let size = CGSize(width: 40, height: 40)
        let cube = SKShapeNode(rectOf: size)
        cube.fillColor = .red
        
        cube.position = CGPoint(x: Int(x), y: Int(y))
        
        let maxX = self.view!.frame.maxX
        let maxY = self.view!.frame.maxY
        
        
        
        addChild(cube)
    }
    
}

struct GameViewRepresentable: NSViewRepresentable {
    let scene: SKScene
    let proxy: GeometryProxy
    let position: Position

    func makeCoordinator() -> Coordinator {
        print("makeCoordinator")
        return Coordinator()
    }

    func makeNSView(context: Context) -> SKView {
        scene.size = proxy.size
        context.coordinator.scene = scene

        let view = SKView()
        view.presentScene(scene)
        
        return view
    }

    func updateNSView(_ nsView: SKView, context: Context) {
        context.coordinator.resizeScene(proxy: proxy, pos: self.position)
        
    }

    class Coordinator: NSObject {
        weak var scene: SKScene?

        func resizeScene(proxy: GeometryProxy, pos: Position) {
            scene?.size = proxy.size
            if let aScene = scene as? GameScene {
                //print("good scene")
    
                let x = pos.worldPosZ * 0.2
                let y = pos.worldPosX * 0.2
                
                print("x: \(x), y: \(y)")
                aScene.draw(x: x, y: y)
            }
        }
    }
}

struct GameView: View {
    let scene: SKScene
    @Binding var position: Position
    // environment??

    var body: some View {
        GeometryReader { proxy in
            GameViewRepresentable(scene: scene, proxy: proxy, position: position)
        }.frame(width: 1000, height: 500, alignment: .center)
            .padding(.bottom, 100)
    }
}

