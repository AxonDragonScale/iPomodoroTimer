//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Ronak Harkhani on 21/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        Home()
            .environmentObject(pomodoroViewModel)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroViewModel())
    }
}
