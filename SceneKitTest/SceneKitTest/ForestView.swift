//
//  ForestView.swift
//  SceneKitTest
//
//  Created by hyebin on 2023/06/05.
//

import SwiftUI

struct ForestView: View {
    @Binding var forest: [Forest]
    @State var showModal = false
    @State var seletedName: String = ""
    
    var body: some View {
        SceneViewWrapper(
            updateObject: .constant(""),
            forest: $forest,
            showModal: $showModal,
            selectedName: $seletedName
        )
        .onAppear(){
            printForest()
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: self.$showModal) {
            ModalView(objectName: $seletedName)
        }
    }
    func printForest() {
        print("print Forest",forest)
    }
}

struct ForestView_Previews: PreviewProvider {
    static var previews: some View {
        ForestView(forest: .constant([]))
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var objectName: String

    var body: some View {
        Group {
            Text(objectName)
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
        }
    }
}
