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
    case printPackets
    case loadData
}

struct DefaultDataCollectionView: View {
    @EnvironmentObject var viewModel: DefaultDataCollectionViewModel
    
    // view model
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack(alignment: .center) {
            HStack(alignment: .top, spacing: 100) {
                Button(action: {
                    viewModel.buttonOnPress(action: .startRecording)
                }, label: {
                    Text("Start Recording")
                })
                
                Button(action: {
                    viewModel.buttonOnPress(action: .stopRecording)
                }, label: {
                    Text("StopRecording")
                })
                
                Button(action: {
                    viewModel.buttonOnPress(action: .saveRecording)
                }, label: {
                    Text("Save Recording")
                })
                
                Button(action: {
                    viewModel.buttonOnPress(action: .deleteRecording)
                }, label: {
                    Text("Delete Recording")
                })
            }
            HStack(alignment: .top, spacing: 100) {
                Button(action: {
                    viewModel.buttonOnPress(action: .printPackets)
                }, label: {
                    Text("Print Packets")
                })
                
                Button(action: {
                    viewModel.buttonOnPress(action: .loadData)
                }, label: {
                    Text("Load Data")
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
        case .printPackets: self.viewModel.printPackets()
        case .loadData: self.viewModel.loadData()
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
