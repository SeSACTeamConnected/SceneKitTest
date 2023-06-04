//
//  PlantView.swift
//  SceneKitTest
//
//  Created by hyebin on 2023/06/05.
//

import SwiftUI

struct PlantView: View {
    @State var moveView = false
    let plants: [Plants] = [
        Plants(
            chapterNum: 1,
            missionIndex: 1,
            plantInfos: [
                PlantInfos(index: 1, fileName: "Tree_small_bare"),
                PlantInfos(index: 2, fileName: "Tree_small_regular")
            ]
        ),
        Plants(
            chapterNum: 1,
            missionIndex: 2,
            plantInfos: [
                PlantInfos(index: 1, fileName: "Tree_small_regular"),
                PlantInfos(index: 2, fileName: "Tree_small_bare")
            ]
        )
    ]
    
    @State var forest = [Forest]()
    
    var body: some View {
        NavigationView() {
            VStack {
                Button(action: {
                    moveView = true
                }, label: {
                    NavigationLink(destination: ForestView(forest: $forest),
                                   isActive: $moveView,
                                   label: {Text("숲으로")}
                    )
                })
                
                TabView {
                    Plant(
                        plantInfo: plants.filter{$0.missionIndex == 1}.first!.plantInfos,
                        forset: $forest
                    )
                    .tabItem {
                        Text("First")
                    }
    
                    Plant(
                        plantInfo: plants.filter{$0.missionIndex == 2}.first!.plantInfos,
                        forset: $forest
                    )
                    .tabItem {
                        Text("Second")
                    }
                }
            }
        }
    }
}

struct Plant: View {
    var plantInfo: [PlantInfos]
    @State var plantIndex: Int = 0
    @State var plantName: String = ""
    @Binding var forset: [Forest]
    
    var body: some View {
        VStack {
            SceneViewWrapper(
                updateObject: $plantName,
                forest: .constant([]),
                showModal: .constant(false),
                selectedName: .constant("")
            )
            .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                if plantIndex < 2 {
                    plantIndex += 1
                    plantName = plantInfo.filter{$0.index == plantIndex}.first!.fileName
                    
                    if plantIndex == 2 {
                        if plantName == "Tree_small_bare" {
                            forset.append(Forest(fileName: plantName, positionX: 0.2, positionY: 0, positionZ: 0))
                        }else {
                            forset.append(Forest(fileName: plantName, positionX: 0, positionY: 3, positionZ: 0))
                        }
                    }
                }
            }, label: {
                Text("Update Plant")
            })
        }
        .onAppear() {
            plantName = "Grass"
        }
        
    }
}

struct PlantView_Previews: PreviewProvider {
    static var previews: some View {
        PlantView()
    }
}
