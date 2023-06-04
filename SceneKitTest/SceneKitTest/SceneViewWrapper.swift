//
//  SceneViewWrapper.swift
//  SceneKitTest
//
//  Created by hyebin on 2023/06/05.
//

import SwiftUI
import SceneKit

struct SceneViewWrapper: UIViewRepresentable {
    let sceneView = SCNView()
    @Binding var updateObject: String
    @Binding var forest: [Forest]
    @Binding var showModal: Bool
    @Binding var selectedName: String
    
    
    func makeUIView(context: Context) -> SCNView {
        sceneView.backgroundColor = .white
        sceneView.scene = createScene()
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.maximumVerticalAngle = 0.001
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if updateObject != "" {
            updateNewObject()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: SceneViewWrapper
        
        init(_ parent: SceneViewWrapper) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            let hitTestResults = parent.sceneView.hitTest(location, options: nil)
            
            if let hitNode = hitTestResults.first?.node {
                parent.showModal = true
                parent.selectedName = hitNode.geometry?.name ?? ""
            }
        }
    }
    
    func createScene() -> SCNScene {
        let scene = SCNScene()
            
        if let landNode = loadSCNFile(named: "land") {
            landNode.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
            scene.rootNode.addChildNode(landNode)
        }
        
        if forest.count > 0 {
            let newNode = addNodeToScene()
            scene.rootNode.addChildNode(newNode!)
        }
        return scene
    }
    
    func addNodeToScene() -> SCNNode? {
        let addNode = SCNNode()
        for i in 0..<forest.count {
            guard let node = loadSCNFile(named: forest[i].fileName) else {
                return nil
            }
            node.position = SCNVector3(
                x: forest[i].positionX,
                y: forest[i].positionY,
                z: forest[i].positionZ
            )
            addNode.addChildNode(node)
        }
        
        return addNode
    }
    
    func loadSCNFile(named name: String) -> SCNNode? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "scn") else {
            print("Failed to find SCN file: \(name).scn")
            return nil
        }
            
        do {
            let scene = try SCNScene(url: url, options: nil)
            
            let node = SCNNode()
            for childNode in scene.rootNode.childNodes {
                node.addChildNode(childNode)
            }
                
            return node
        } catch {
            print("Failed to load SCN file: \(error)")
            return nil
        }
    }
    
    func updateNewObject() {
        let scene = createScene()
        
        guard let node = loadSCNFile(named: updateObject) else {
            return
        }
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(node)
        
        sceneView.scene = scene
    }
    
}
