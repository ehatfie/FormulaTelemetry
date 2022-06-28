//
//  TelemetryView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/29/21.
//

import SwiftUI
import F12020TelemetryPackets

struct BrakeTemps {
    let fl: Int
    let fr: Int
    let rl: Int
    let rr: Int
    
    init(data: CarTelemetryData) {
        guard data.brakesTemperature.count == 4 else {
            self.fl = 0
            self.fr = 0
            self.rl = 0
            self.rr = 0
            
            return
        }
        
        let temps = data.brakesTemperature
        
        self.fl = temps[0]
        self.fr = temps[1]
        self.rl = temps[2]
        self.rr = temps[3]
    }
}


// probably gonna have multiple views we use here
struct TelemetryView: View {
    @Binding var telemetryData: CarTelemetryData
    @Binding var telemetryStuff: LapSummaryHandler
    
    var body: some View {
        VStack {
            Text(verbatim: "throttle \(telemetryData.throttle)")
            Text(verbatim: "steer \(telemetryData.steer)")
            Text(verbatim: "brake \(telemetryData.brake)")
            Text(verbatim: "clutch \(telemetryData.clutch)")
            
            
            Text(verbatim: "DRS \(telemetryData.drs)")
            HStack {
                Text(verbatim: "speed \(telemetryData.speed)")
                Text(verbatim: "RPM \(telemetryData.engineRPM)")
                Text(verbatim: "gear \(telemetryData.gear)")
            }
            TireData()
            SurfaceType()
            BrakeTempsView()
        }.frame(alignment: .leading).border(.blue, width: 1)
    }
    
    func TireData() -> some View {
        VStack {
            Text("Tire Surface Temp")
            TireInput(data: telemetryData.tiresSurfaceTemperature)
        }
    }
    
    func SurfaceType() -> some View {
        VStack {
            Text("Surface Type")
            TireInput(data: telemetryData.surfaceType)
        }
    }
    
    func TireInput(data: [Int]) -> some View {
        VStack {
            HStack {
                Text(verbatim: "0 \(data[0])")
                Text(verbatim: "1 \(data[1])")
            }
            HStack {
                Text(verbatim: "2 \(data[2])")
                Text(verbatim: "3 \(data[3])")
            }
        }
    }
    
    func BrakeTempsView() -> some View {
        let brakeTemps = BrakeTemps(data: self.telemetryData)
        return VStack {
                Text("Brake Temps")
                VStack {
                    HStack {
                        Text(verbatim: "0 \(brakeTemps.fl)")
                        Text(verbatim: "1 \(brakeTemps.fr)")
                    }
                    HStack {
                        Text(verbatim: "2 \(brakeTemps.rl)")
                        Text(verbatim: "3 \(brakeTemps.rr)")
                    }
                }
            }
    }
}

//struct TelemetryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TelemetryView()
//    }
//}
