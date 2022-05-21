//
//  PomodoroViewModel.swift
//  PomodoroTimer
//
//  Created by Ronak Harkhani on 21/05/22.
//

import Foundation
import SwiftUI

class PomodoroViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var addNewTimer: Bool = false
    @Published var isStarted: Bool = false
    @Published var isFinished: Bool = false
    @Published var progress: CGFloat = 1
    @Published var timerString: String = "00:00"
    
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    @Published var totalTime: Int = 0
    @Published var timeRemaining: Int = 0
    
    override init() {
        super.init()
        requestNotificationAccess()
    }
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
            addNewTimer = false
        }
        
        timerString = buildTimerString()
        totalTime = hours * 60 * 60 + minutes * 60 + seconds
        timeRemaining = totalTime
        
        showNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            hours = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        
        timeRemaining = 0
        totalTime = 0
        timerString = "00:00"
    }
    
    func updateTimer() {
        if !isStarted { return }
        
        timeRemaining -= 1
        progress = CGFloat(timeRemaining) / CGFloat(totalTime)
        
        hours = timeRemaining / 3600
        minutes = (timeRemaining / 60) % 60
        seconds = timeRemaining % 60
        timerString = buildTimerString()
        
        if timeRemaining == 0 {
            isStarted = false
            isFinished = true
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.sound, .banner])
    }
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
            // Nothing
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func showNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.subtitle = "Congratulations! You did it."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTime), repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }

    private func buildTimerString() -> String {
        let hoursString = hours == 0 ? "" : (hours < 10 ? "0\(hours):" : "\(hours):")
        let minutesString = (hours < 10 ? "0\(minutes):" : "\(minutes):")
        let secondsString = (seconds < 10 ? "0\(seconds)" : "\(seconds)")
        return hoursString + minutesString + secondsString
    }
}
