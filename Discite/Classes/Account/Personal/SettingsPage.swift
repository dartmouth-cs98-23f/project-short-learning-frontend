//
//  Settings.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//

import SwiftUI

struct Settings: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("selectedTheme") private var selectedTheme = 0
    let themes = ["Light", "Dark", "System"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(0..<themes.count) { index in
                            Text(themes[index])
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onChange(of: notificationsEnabled) { newValue in
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
            // Apply notification settings here
        }
        .onChange(of: darkModeEnabled) { newValue in
            UserDefaults.standard.set(newValue, forKey: "darkModeEnabled")
            // Apply dark mode settings here
        }
        .onChange(of: selectedTheme) { newValue in
            UserDefaults.standard.set(newValue, forKey: "selectedTheme")
            // Apply theme settings here
        }
    }
}

#Preview {
    Settings()
}
