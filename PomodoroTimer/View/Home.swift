//
//  Home.swift
//  PomodoroTimer
//
//  Created by Ronak Harkhani on 21/05/22.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.title.bold())
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    
                    ZStack {
                        // Outer BG
                        Circle()
                            .fill(.white.opacity(0.05))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroViewModel.progress)
                            .stroke(.white.opacity(0.05), lineWidth: 40)
                            .padding(-20)

                        // Shadow
                        Circle()
                            .stroke(Color.purple, lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        // Inner BG
                        Circle()
                            .fill(Color("BG"))
                        
                        // Progress Stroke
                        Circle()
                            .trim(from: 0, to: pomodoroViewModel.progress)
                            .stroke(Color.purple.opacity(0.8), lineWidth: 10)
                        
                        GeometryReader { proxy in
                            Circle()
                                .fill(.purple)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                }
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height,
                                    alignment: .center
                                )
                                .offset(x: proxy.size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroViewModel.progress * 360))
                            
                        }
                        
                        Text(pomodoroViewModel.timerString)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroViewModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroViewModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button(action: {
                        if pomodoroViewModel.isStarted {
                            pomodoroViewModel.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        } else {
                            pomodoroViewModel.addNewTimer = true
                        }
                    }) {
                        Image(systemName: pomodoroViewModel.isStarted ? "stop.fill" : "timer")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background {
                                Circle()
                                    .fill(.purple)
                            }
                            .shadow(color: .purple, radius: 8, x: 0, y: 0)
                    }

                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
            }
        }
        .padding()
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .overlay {
            ZStack {
                Color.black
                    .opacity(pomodoroViewModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        pomodoroViewModel.hours = 0
                        pomodoroViewModel.minutes = 0
                        pomodoroViewModel.seconds = 0
                        pomodoroViewModel.addNewTimer = false
                    }
                
                NewTimer()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroViewModel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: pomodoroViewModel.addNewTimer)
        }
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            pomodoroViewModel.updateTimer()
        }
        .alert("Congratulations! You did it. \nPat yourself on the back and take a break.", isPresented: $pomodoroViewModel.isFinished) {
            Button("Close", role: .destructive) {
                pomodoroViewModel.stopTimer()
            }
            Button("Start New Timer", role: .cancel) {
                pomodoroViewModel.stopTimer()
                pomodoroViewModel.addNewTimer = true
            }
        }
    }
    
    @ViewBuilder
    func NewTimer() -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.title.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(pomodoroViewModel.hours) hrs")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.05))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 24, hint: "hrs") { value in
                            pomodoroViewModel.hours = value
                        }
                    }
                
                Text("\(pomodoroViewModel.minutes) mins")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.05))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "mins") { value in
                            pomodoroViewModel.minutes = value
                        }
                    }
                
                Text("\(pomodoroViewModel.seconds) secs")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.05))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "secs") { value in
                            pomodoroViewModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button(action: { pomodoroViewModel.startTimer() }) {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(.purple)
                    }
            }
            .disabled(pomodoroViewModel.seconds == 0)
            .opacity(pomodoroViewModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func ContextMenuOptions(
        maxValue: Int,
        hint: String,
        onClick: @escaping (Int) -> ()
    ) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroViewModel())
    }
}
