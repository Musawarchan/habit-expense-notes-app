# SmartLife - AI-Powered Productivity Companion

A comprehensive Flutter application that combines habit tracking, task management, expense tracking, note-taking, and AI-powered insights into one unified platform.

## 🚀 Features

### Core Features
- **Habits & Tasks**: Track daily habits and manage tasks with streaks and completion tracking
- **Expense Tracking**: Monitor spending with categories, budgets, and analytics
- **Notes & Quick Capture**: Write and organize notes with tagging and search
- **AI Assistant**: Gemini-powered insights and personalized recommendations
- **Modern UI**: Clean, elegant design with dark/light theme support

### Technical Features
- **Clean Architecture**: BLoC pattern with proper separation of concerns
- **Firebase Integration**: Authentication, Firestore, and Storage
- **Local Storage**: Hive for offline-first functionality
- **Modern Navigation**: GoRouter for type-safe routing
- **Responsive Design**: Works on mobile, tablet, and desktop

## 📱 Screenshots

The app includes:
- Splash screen with animated logo
- Authentication (Login/Register) with Google sign-in
- Dashboard with overview cards and quick actions
- Individual screens for Habits, Tasks, Expenses, Notes
- AI Assistant with chat interface
- Settings with theme customization

## 🏗️ Architecture

```
lib/
├── core/                           # Global utilities
│   ├── constants/                 # Colors, strings, keys
│   ├── theme/                     # Light/Dark themes
│   ├── utils/                     # Helpers (validators, formatters)
│   └── widgets/                   # Reusable UI widgets
├── data/                           # Data layer
│   ├── models/                    # Data models
│   ├── repositories/              # Abstract repositories
│   └── services/                  # External services
├── logic/                          # Business Logic Layer (BLoC)
│   ├── auth/                      # Authentication
│   ├── habit/                     # Habit tracking
│   ├── task/                       # Task management
│   ├── expense/                    # Expense tracking
│   ├── note/                       # Note management
│   └── ai/                         # AI integration
└── presentation/                   # UI Layer
    ├── screens/                    # Feature screens
    └── widgets/                    # Feature-specific widgets
```

## 🛠️ Tech Stack

- **Flutter**: Cross-platform UI framework
- **BLoC**: State management
- **Firebase**: Backend services
- **Hive**: Local database
- **GoRouter**: Navigation
- **Equatable**: Value equality
- **Fl Chart**: Data visualization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2+)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd smartlife_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Enable Authentication, Firestore, and Storage

4. Run the app
```bash
flutter run
```

## 🔧 Configuration

### Firebase Setup
1. Create a new Firebase project
2. Enable Authentication (Email/Password and Google)
3. Create Firestore database
4. Enable Storage
5. Add your API keys to the project

### Gemini AI Setup
1. Get your Gemini API key from Google AI Studio
2. Update `AppConstants.geminiApiKey` with your key
3. Configure the API endpoint if needed

## 📦 Dependencies

Key dependencies include:
- `flutter_bloc`: State management
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Firebase services
- `hive`, `hive_flutter`: Local storage
- `go_router`: Navigation
- `equatable`: Value equality
- `fl_chart`: Charts and graphs
- `intl`: Internationalization
- `image_picker`: Image handling

## 🎨 UI/UX Features

- **Material Design 3**: Modern design system
- **Dark/Light Themes**: Automatic theme switching
- **Custom Backgrounds**: User-selectable wallpapers
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Engaging user interactions
- **Accessibility**: Screen reader support

## 🔮 Future Enhancements

- [ ] Push notifications for reminders
- [ ] Data export/import functionality
- [ ] Advanced analytics and insights
- [ ] Team collaboration features
- [ ] Voice notes and transcription
- [ ] Integration with calendar apps
- [ ] Widget support for home screen
- [ ] Apple Watch companion app

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google AI for Gemini integration
- Open source community for various packages

---

**SmartLife** - Empowering productivity through AI-driven insights and comprehensive life management.# habit-expense-notes-app
