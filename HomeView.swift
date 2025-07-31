import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @State private var showingAddHabit = false
    @State private var showingConfetti = false
    @State private var confettiView = ConfettiView()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    if habits.isEmpty {
                        emptyStateView
                    } else {
                        habitListView
                    }
                }
                
                // Confetti overlay
                if showingConfetti {
                    confettiView
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle("Habito")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No Habits Yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Tap the + button to create your first habit")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var habitListView: some View {
        List {
            ForEach(habits) { habit in
                HabitRowView(habit: habit) {
                    completeHabit(habit)
                }
            }
            .onDelete(perform: deleteHabits)
        }
        .listStyle(PlainListStyle())
    }
    
    private func completeHabit(_ habit: Habit) {
        let calendar = Calendar.current
        let today = Date()
        
        // Check if habit was already completed today
        if let lastCompleted = habit.lastCompletedDate,
           calendar.isDate(lastCompleted, inSameDayAs: today) {
            return // Already completed today
        }
        
        // Check if it's a consecutive day
        if let lastCompleted = habit.lastCompletedDate {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
            if calendar.isDate(lastCompleted, inSameDayAs: yesterday) {
                // Consecutive day - increment streak
                habit.streakCount += 1
            } else {
                // Break in streak - reset to 1
                habit.streakCount = 1
            }
        } else {
            // First time completing
            habit.streakCount = 1
        }
        
        habit.lastCompletedDate = today
        
        do {
            try viewContext.save()
            triggerConfetti()
        } catch {
            print("Error saving habit: \(error)")
        }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting habit: \(error)")
            }
        }
    }
    
    private func triggerConfetti() {
        showingConfetti = true
        confettiView.triggerAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showingConfetti = false
        }
    }
}

struct HabitRowView: View {
    let habit: Habit
    let onTap: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Circular progress indicator for streak
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(habit.streakCount) / 10.0, 1.0))
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(habit.streakCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name ?? "Unnamed Habit")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if let lastCompleted = habit.lastCompletedDate {
                        Text("Last completed: \(formatDate(lastCompleted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Not started yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Check if completed today
                if let lastCompleted = habit.lastCompletedDate,
                   Calendar.current.isDateInToday(lastCompleted) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 