//
//  NovawaveManagementAppApp.swift
//  NovawaveManagementApp
//
//  Created by Gabriella Piacentino on 4/28/23.
//


import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct NovawaveManagementAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var customerVM = CustomerViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(customerVM)
        }
    }
}

