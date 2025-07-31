# Habito 🔥

A beautiful and intuitive habit tracking iOS app built with SwiftUI and CoreData. Track your daily habits, build streaks, and stay motivated with visual feedback and daily reminders.

## ✨ Features

### 🎯 Core Functionality

- **Habit Tracking**: Create and manage your daily habits
- **Streak Counter**: Visual flame icon (🔥) showing your current streak
- **Smart Completion**: Only allows one completion per day to maintain streak integrity
- **Swipe to Delete**: Easy habit management with swipe gestures

### 🎨 Beautiful UI/UX

- **Modern Design**: Clean, intuitive interface with gradient backgrounds
- **Dark Mode Support**: Fully optimized for both light and dark themes
- **Circular Progress**: Visual streak indicator with animated progress rings
- **Colorful Cards**: Each habit displayed in an attractive card layout
- **SF Symbols**: Native iOS icons for consistent design language

### 🎉 Interactive Elements

- **Confetti Animation**: Celebratory particle effects when completing habits
- **Visual Feedback**: Immediate response to user actions
- **Smooth Animations**: Fluid transitions and state changes

### 🔔 Smart Notifications

- **Daily Reminders**: Automatic 8 PM notifications to check your habits
- **Permission Handling**: Graceful notification permission requests
- **Customizable**: Easy to modify notification timing and content

## 🛠 Technical Stack

- **Framework**: SwiftUI
- **Data Persistence**: CoreData
- **Notifications**: UserNotifications framework
- **Target**: iOS 17.0+
- **Architecture**: MVVM with ObservableObject

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS 14.0+ (for development)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/arzucaner/habito.git
   cd habito
   ```
2. Open the project in Xcode:

   ```bash
   open Habito.xcodeproj
   ```
3. Build and run the project:

   - Select your target device or simulator
   - Press `Cmd + R` or click the Run button

### Project Structure

```
Habito/
├── HabitoApp.swift              # Main app entry point
├── ContentView.swift            # Root view container
├── HomeView.swift              # Main habit list view
├── AddHabitView.swift          # Habit creation form
├── ConfettiView.swift          # Animation component
├── NotificationManager.swift   # Notification handling
├── PersistenceController.swift # CoreData management
├── Habito.xcdatamodeld/        # CoreData model
└── Assets.xcassets/            # App assets
```

## 🎯 CoreData Model

The app uses a simple but effective CoreData model:

```swift
Entity: Habit
├── name: String (habit name)
├── streakCount: Int16 (current streak)
└── lastCompletedDate: Date (last completion date)
```

## 🔧 Key Features Implementation

### Streak Logic

- Tracks consecutive days of habit completion
- Resets streak if a day is missed
- Visual flame icon with count display

### Confetti Animation

- Custom particle system using SwiftUI
- Triggers on successful habit completion
- 2-second duration with fade-out effect

### Notification System

- Daily reminder at 8 PM
- Permission request on first launch
- Customizable notification content

## 🎨 UI/UX Highlights

- **Gradient Backgrounds**: Subtle gradients for visual appeal
- **Circular Progress**: Animated progress rings for streak visualization
- **Card Design**: Modern card-based layout for habits
- **Color Coordination**: Consistent color scheme throughout
- **Accessibility**: Built with accessibility in mind

## 📈 Future Enhancements

- [ ] Habit categories and tags
- [ ] Weekly/monthly statistics
- [ ] Habit sharing with friends
- [ ] Custom notification times
- [ ] Widget support
- [ ] iCloud sync
- [ ] Export/import functionality

## 🤝 Contributing

This is a learning project for SwiftUI and CoreData. Feel free to:

- Fork the repository
- Create feature branches
- Submit pull requests
- Report issues

## 🙏 Acknowledgments

- Built as a SwiftUI + CoreData learning project
- Inspired by popular habit tracking apps
- Uses Apple's Human Interface Guidelines
- Leverages native iOS frameworks for optimal performance

---

**Built with ❤️ using SwiftUI and CoreData**

*Perfect for learning iOS development, CoreData integration, and modern SwiftUI patterns.*
