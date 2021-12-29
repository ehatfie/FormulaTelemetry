//
//  SessionView.swift
//  FormulaTelemetry
//
//  Created by Erik Hatfield on 12/9/21.
//

import SwiftUI
import F12020TelemetryPackets

struct SessionView: View {
    @Binding var sessionData: SessionData
    
    var body: some View {
        VStack {
            Text(verbatim: "trackID \(sessionData.trackName)")
            Text(verbatim: "sessionType \(sessionData.sessionType)")
            Text(verbatim: "Total Laps: \(sessionData.totalLaps)")
            Text(sessionTime(time: sessionData.sessionTime))
            Text(verbatim: "Session Duration: \(sessionData.sessionDuration)")
            Text(verbatim: "Session Time Left: \(sessionData.sessionTimeLeft)")
        }
    }
    
    func sessionTime(time: Float?) -> String {
        guard let sessionTime = time else {
            return "No Time"
        }
        
        return "Session Time: \(sessionTime)"
    }
}
