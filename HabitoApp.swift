import SwiftUI
import CoreData

@main
struct HabitoApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestPermission()
                    notificationManager.scheduleDailyReminder()
                }
        }
    }
} 