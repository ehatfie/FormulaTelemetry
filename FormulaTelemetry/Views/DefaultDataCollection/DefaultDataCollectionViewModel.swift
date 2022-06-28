//
//  DefaultDataCollectionViewModel.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 6/28/22.
//

import SwiftUI
import Combine

protocol DefaultDataCollectionViewModelInterface: ObservableObject {
    var udpHandler: UDPHandler { get set }
    
    func startRecording()
    func stopRecording()
    func saveRecording()
    func deleteRecording()
}
/*
    This should start/stop collection
    display some information about the collection
 */
class DefaultDataCollectionViewModel: DefaultDataCollectionViewModelInterface {
    @ObservedObject var client = UDPClient()
    
    @ObservedObject var dataCollectionHandler: DataCollectionHandler
    
    @Published var test: Int = 0
    
    var dispatchQueue: DispatchQueue?
    
    var udpHandler: UDPHandler = UDPHandler()
    
    var cancell: Cancellable?
    
    init() {
        self.dataCollectionHandler = DataCollectionHandler(pub: udpHandler.dataPublisher)

        dataCollectionHandler.$count.assign(to: &$test)
    }
    
    func startRecording() {
        print("Start Recording")

        let dispatchQueue = DispatchQueue(label: "test")
        self.dispatchQueue = dispatchQueue
        
        dispatchQueue.async { [ weak self] in
            guard let self = self else {
                return
            }
            self.client.start(handler: self.udpHandler)
        }
        
       // self.client.start(handler: self.udpHandler)
    }
    
    func stopRecording() {
        print("Stop Recording")
        self.client.stop()
    }
    
    func saveRecording() {
        print("Save Recording")
        //self.dataCollectionHandler.count += 1
        self.test += 1
    }
    
    func deleteRecording() {
        print("Delete Recording")
    }
}
