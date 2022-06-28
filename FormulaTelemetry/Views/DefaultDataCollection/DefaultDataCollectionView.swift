//
//  DefaultDataCollection.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/28/22.
//

import SwiftUI

protocol DefaultDataCollectionViewInterface {
    
}

enum DefaultDataCollectionAction {
    case startRecording
    case stopRecording
    case saveRecording
    case deleteRecording
}

struct DefaultDataCollectionView: View {
    @EnvironmentObject var viewModel: DefaultDataCollectionViewModel
    
    // view model
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            HStack(alignment: .top, spacing: 100) {
                Button(action: {
                    buttonOnPress(action: .startRecording)
                }, label: {
                    Text("Start Recording")
                })
                Button(action: {
                    buttonOnPress(action: .stopRecording)
                }, label: {
                    Text("StopRecording")
                })
                Button(action: {
                    buttonOnPress(action: .saveRecording)
                }, label: {
                    Text("Save Recording")
                })
                
                Button(action: {
                    buttonOnPress(action: .deleteRecording)
                }, label: {
                    Text("Delete Recording")
                })
            }
            Text(verbatim: "\(viewModel.test)")
            //Text(verbatim: "\(viewModel.dataCollectionHandler.count)")
        }
        
        
    }
    
    func buttonOnPress(action: DefaultDataCollectionAction) {
        switch action {
        case .startRecording: self.viewModel.startRecording()
        case .stopRecording: self.viewModel.stopRecording()
        case .deleteRecording: self.viewModel.deleteRecording()
        case .saveRecording: self.viewModel.saveRecording()
        }
    }
    
    func startRecordingOnPress() {
        
    }
}

struct DefaultDataCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultDataCollectionView()
    }
}
