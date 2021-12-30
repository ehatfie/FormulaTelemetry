//
//  LapDataView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/29/21.
//

import SwiftUI
import F12020TelemetryPackets
/**
 Here we are going to want to handle displaying collected data during a lap
 */
struct LapDataView: View {
    @Binding var source: LapDataHandler
    
    var body: some View {
        //printSomething()
        
        source.lastLapData
            .map { lapData in
                VStack {
                    Text("L \(lapData.currentLapNum)")
                    HStack {
                        VStack {
                            Text("lastLapTime")
                            Text("\(lapData.lastLapTime)")
                        }
                        VStack {
                            Text("currentLapTime")
                            Text("\(lapData.currentLapTime)")
                        }
                        VStack {
                            Text("best")
                            Text("\(lapData.bestLapTime)")
                        }
                    }.border(.green, width: 1)
                    
                    HStack {
                        VStack {
                            Text("S1")
                            Text("\(lapData.sector1Time)")
                        }
                        VStack {
                            Text("S2")
                            Text("\(lapData.sector2Time)")
                        }
                        VStack {
                            Text("S3")
                            Text("")
                        }
                    }
                    
                }
                
            }
    }
    
    func printSomething() -> some View {
        guard let lapData = self.source.lastLapData else {
            return Text("No Lap Data")
        }
        
        return Text("lapData: \(lapData.bestLapNum)")
    }
}
