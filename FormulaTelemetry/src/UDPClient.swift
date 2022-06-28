//
//  UDPClient.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 11/10/21.
//

import Foundation
import NIO

protocol UDPClientInterface: ObservableObject {
    var handler: UDPHandler? { get set }
    var channel: Channel? { get set }
}

class UDPClient: UDPClientInterface {
    @Published var isConnected = false
    
    var handler: UDPHandler?
    var channel: Channel?
    var eventLoopGroup: MultiThreadedEventLoopGroup?
    
    func start(handler: UDPHandler) {
        self.handler = handler
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.eventLoopGroup = group
        let datagramBootstrap = DatagramBootstrap(group: group)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr),value: 1)
            .channelInitializer({ channel in
                return channel.pipeline.addHandler(handler)
            })
        
        defer {
            print("DEFER")
            try! group.syncShutdownGracefully()
        }
        
        let defaultPort = 20777
        
        let arguments = CommandLine.arguments
        
        let port = arguments.dropFirst() // drop first argument
            .compactMap {Int($0)} // remove nil values and convert to Int
            .first ?? defaultPort // get port or use default if no valid port was provided
        
        // TODO: get this address from commandline
        let bindToAddress = "192.168.1.206"
        
        do {
            let channel = try datagramBootstrap.bind(host: bindToAddress, port: port).wait()
            DispatchQueue.main.async { [weak self] in
                self?.isConnected = true
            }
            
            print("Channel accepting connections on \(channel.localAddress!))")
            
            try channel.closeFuture.wait()
            
        } catch let error {
            print("ERROR CATCH \(error)")
            
        }
        self.isConnected = false
        print("Channel closed")
    }
    
    func stop() {
        print("UDP Client stop")
        try? self.eventLoopGroup?.syncShutdownGracefully()
        //let foo = self.channel?.close()
        //try? foo?.wait()
        self.channel = nil
        self.isConnected = false
    }
}
