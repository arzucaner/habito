import SwiftUI
import CoreData

struct AddHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create New Habit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Habit Name")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter habit name...", text: $habitName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
                .padding(.horizontal)
                
                Button(action: addHabit) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Habit")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addHabit() {
        let trimmedName = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            alertMessage = "Please enter a habit name"
            showingAlert = true
            return
        }
        
        let newHabit = Habit(context: viewContext)
        newHabit.name = trimmedName
        newHabit.streakCount = 0
        newHabit.lastCompletedDate = nil
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            alertMessage = "Failed to save habit: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    AddHabitView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 