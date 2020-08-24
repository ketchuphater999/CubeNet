//
//  CubeViewController.swift
//  CubeNet
//
//  Created by Maya Luna Celeste on 8/20/20.
//  Copyright © 2020 Maya Luna Celeste. All rights reserved.
//

import Cocoa
import SceneKit
import QuartzCore
import AVFoundation

class CubeViewController: NSViewController {
    
    
    var cube : Cube!
    var turning : Bool = false
    let cubeNode : SCNNode = SCNNode()
    let layerNode : SCNNode = SCNNode()
    var player : AVAudioPlayer!
    
    let uNodes = ["yob","ygo","yrg","ybr"]
    let dNodes = ["wbo","wrb","wgr","wog"]
    let rNodes = ["ybr","yrg","wgr","wrb"]
    let lNodes = ["ygo","yob","wbo","wog"]
    let fNodes = ["ybr","wrb","wbo","yob"]
    let bNodes = ["wgr","yrg","ygo","wog"]
    let cubeNodes = ["yob","ygo","yrg","ybr","wbo","wrb","wgr","wog"]
    
    let queue = DispatchQueue(label: "com.mayanyaa.CubeNet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        //create a model
        cube = Cube()
        
        //load the cube
        let scene = SCNScene(named: "assets/scene.scn")!
        
        //initialize cubeNode with all cubies and add it to the scene
        cubeNode.addChildNode(layerNode)
        scene.rootNode.enumerateChildNodes({node,stop in
            if node.geometry != nil { cubeNode.addChildNode(node) }
        })
        scene.rootNode.addChildNode(cubeNode)
        
        //display the cube
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
        
        //monitor keypress
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyPressed(with: $0)
            return $0
        }
        
        //init audio player
        let url = Bundle.main.url(forResource: "turn", withExtension: "wav", subdirectory: "assets")
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
        } catch let error as NSError {
            print(error.description)
        }
        
        player?.prepareToPlay()
    }
    
    override func keyDown(with event: NSEvent) {    }
    func keyPressed(with event: NSEvent) {
        var double = false
        if event.isARepeat { return }
        if event.modifierFlags.contains(.control) { double = true }
        let key = event.charactersIgnoringModifiers ?? ""
        
        handleKeystroke(key)
    }
    
    func handleKeystroke(_ key : String) {
        switch key {
        case "R":
            turn(moveType: Cube.MoveType.right, prime: true)
        case "L":
            turn(moveType: Cube.MoveType.left, prime: true)
        case "U":
            turn(moveType: Cube.MoveType.up, prime: true)
        case "D":
            turn(moveType: Cube.MoveType.down, prime: true)
        case "F":
            turn(moveType: Cube.MoveType.front, prime: true)
        case "B":
            turn(moveType: Cube.MoveType.back, prime: true)
        case "r":
            turn(moveType: Cube.MoveType.right, prime: false)
        case "l":
            turn(moveType: Cube.MoveType.left, prime: false)
        case "u":
            turn(moveType: Cube.MoveType.up, prime: false)
        case "d":
            turn(moveType: Cube.MoveType.down, prime: false)
        case "f":
            turn(moveType: Cube.MoveType.front, prime: false)
        case "b":
            turn(moveType: Cube.MoveType.back, prime: false)
        default: break
        }
    }
    
    func turn(moveType: Cube.MoveType, prime: Bool) {
        if turning { return }
        turning = true
        cube.turn(moveType, prime: prime)
        var nodeLabels : [String] = []
        var rotation : SCNVector3!
        
        switch moveType {
        case Cube.MoveType.up:
            nodeLabels = uNodes
            rotation = SCNVector3Make(0, CGFloat(Double.pi / -2), 0)
        case Cube.MoveType.down:
            nodeLabels = dNodes
            rotation = SCNVector3Make(0, CGFloat(Double.pi / 2), 0)
        case Cube.MoveType.right:
            nodeLabels = rNodes
            rotation = SCNVector3Make(CGFloat(Double.pi / -2), 0, 0)
        case Cube.MoveType.left:
            nodeLabels = lNodes
            rotation = SCNVector3Make(CGFloat(Double.pi / 2), 0, 0)
        case Cube.MoveType.front:
            nodeLabels = fNodes
            rotation = SCNVector3Make(0, 0, CGFloat(Double.pi / -2))
        case Cube.MoveType.back:
            nodeLabels = bNodes
            rotation = SCNVector3Make(0, 0, CGFloat(Double.pi / 2))
        }
        
        for label in nodeLabels {
            layerNode.addChildNode(cubeNode.childNode(withName: label, recursively: true)!)
        }

        if prime {
            rotation = SCNVector3Make(rotation.x * -1, rotation.y * -1, rotation.z * -1)
        }
        
        player.stop()
        turnNoise()
        layerNode.runAction(SCNAction.rotateBy(x: rotation.x, y: rotation.y, z: rotation.z, duration: 0.15)) {
            
            if prime {
                var nodes : [SCNNode] = []
                var lastPositions : [SCNVector3] = []
                for i in 0 ..< nodeLabels.count {
                    nodes.append(self.layerNode.childNode(withName: nodeLabels[i], recursively: true)!)
                    lastPositions.append(nodes.last!.position)
                    
                    let oldQuat = nodes.last!.simdOrientation
                    let axis = clamp(float3([Float(rotation.x),Float(rotation.y),Float(rotation.z)]), min: -1, max: 1)
                    let rotationQuat = simd_quatf(angle: Float(Double.pi / 2),axis: axis)
                    nodes.last!.simdOrientation = rotationQuat * oldQuat
                }
                for i in 1 ..< nodeLabels.count {
                    nodes[i].name = nodeLabels[i-1]
                    nodes[i].position = lastPositions[i-1]
                }
                nodes.first!.name = nodeLabels.last!
                nodes.first!.position = lastPositions.last!
            } else {
                var nodes : [SCNNode] = []
                var lastPositions : [SCNVector3] = []
                for i in 0 ..< nodeLabels.count {
                    nodes.append(self.layerNode.childNode(withName: nodeLabels[i], recursively: true)!)
                    lastPositions.append(nodes.last!.position)
                    
                    let oldQuat = nodes.last!.simdOrientation
                    let axis = clamp(float3([Float(rotation.x),Float(rotation.y),Float(rotation.z)]), min: -1, max: 1)
                    let rotationQuat = simd_quatf(angle: Float(Double.pi / 2),axis: axis)
                    nodes.last!.simdOrientation = rotationQuat * oldQuat
                }
                for i in 0 ..< nodeLabels.count - 1 {
                    nodes[i].name = nodeLabels[i+1]
                    nodes[i].position = lastPositions[i+1]
                }
                nodes.last!.name = nodeLabels[0]
                nodes.last!.position = lastPositions[0]
            }
            
            self.layerNode.enumerateChildNodes({node,_ in
                self.cubeNode.addChildNode(node)
            })
            
            self.layerNode.simdEulerAngles = [0,0,0]
            self.turning = false
        }
    }
    
    func turnNoise(){
        queue.async {
            self.player?.play()
        }
    }
    
}
