//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Ronak Harkhani on 21/05/22.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    
    @StateObject var pomodoroViewModel: PomodoroViewModel = .init()
    @State var lastActiveTime: Date = Date()
    @Environment(\.scenePhase) var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroViewModel)
        }
        .onChange(of: phase) { phase in
            if pomodoroViewModel.isStarted {
                if phase == .background {
                    lastActiveTime = Date()
                }
                if phase == .active {
                    let timeSinceLastActive = Int(Date().timeIntervalSince(lastActiveTime))
                    if pomodoroViewModel.timeRemaining - timeSinceLastActive <= 0 {
                        pomodoroViewModel.isStarted = false
                        pomodoroViewModel.timeRemaining = 0
                        pomodoroViewModel.isFinished = true
                    } else {
                        pomodoroViewModel.timeRemaining -= timeSinceLastActive
                    }
                }
            }
            
        }
    }
}
