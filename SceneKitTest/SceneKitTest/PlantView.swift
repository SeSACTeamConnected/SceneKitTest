//
//  PlantView.swift
//  SceneKitTest
//
//  Created by hyebin on 2023/06/05.
//

import SwiftUI
import SceneKit

struct PlantView: View {
    var body: some View {
        ZStack {
            Image("STR_Img_bg_1_spring")
                .resizable()
                .ignoresSafeArea()
            //MARK: 3d file name 변경 (dae file editor에서 .scn으로 변환 후 사용)
            PlantSceneView(sceneViewName: .constant("dandelion_1.scn"))
                .frame(width: 300, height: 500)
        }
    }
}

struct PlantSceneView: UIViewRepresentable {
    let sceneView = SCNView()
    @Binding var sceneViewName: String
    
    func makeUIView(context: Context) -> SCNView {
        sceneView.backgroundColor = .clear
        sceneView.scene = SCNScene(named: sceneViewName)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        //sceneView.defaultCameraController.maximumVerticalAngle = 0.001
        
        return sceneView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = SCNScene(named: sceneViewName)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject {
        let parent: PlantSceneView
        
        init(_ parent: PlantSceneView) {
            self.parent = parent
        }
        
    }
}

struct PlantView_Previews: PreviewProvider {
    static var previews: some View {
        PlantView()
    }
}
