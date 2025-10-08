# SmartLife App - Features Documentation

## Overview
SmartLife is a comprehensive productivity companion app that helps users track habits, manage tasks, and monitor expenses. The app is built using Flutter with BLoC pattern for state management and Firebase for backend services.

## Architecture

### Design Pattern
- **BLoC (Business Logic Component)**: Used for state management across all features
- **Repository Pattern**: Abstracts data sources (Firebase Firestore)
- **Clean Architecture**: Separation of concerns between presentation, business logic, and data layers

### Project Structure
```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/          # Theme configuration
│   └── utils/          # Utility functions
├── logic/              # Business logic layer
│   ├── habit/         # Habit management
│   ├── task/          # Task management
│   ├── expense/       # Expense management
│   ├── auth/          # Authentication
│   └── profile/       # User profile
├── presentation/       # UI layer
│   ├── screens/       # App screens
│   └── widgets/       # Reusable widgets
└── routes/            # Navigation configuration
```

## Features

### 1. Habit Management

#### Overview
Track daily habits, build streaks, and develop positive routines.

#### Key Features
- **Create Habits**: Add new habits with name, description, category, and frequency
- **Track Progress**: Mark habits as completed for the day
- **Streak Tracking**: Monitor current and longest streaks
- **Categories**: Organize habits by Health, Fitness, Productivity, Mindfulness, Learning, Social, Personal, and Other
- **Statistics**: View completion rates, active habits, and today's progress
- **Real-time Updates**: Automatic synchronization with Firestore

#### BLoC Components
- **Events**: 
  - `HabitLoadRequested`: Load all habits
  - `HabitAddRequested`: Add new habit
  - `HabitUpdateRequested`: Update existing habit
  - `HabitDeleteRequested`: Delete habit
  - `HabitCompleteRequested`: Mark habit as completed
  - `HabitToggleActiveRequested`: Toggle habit active status

- **States**:
  - `HabitInitial`: Initial state
  - `HabitLoading`: Loading habits
  - `HabitLoaded`: Habits successfully loaded
  - `HabitOperationInProgress`: Operation in progress
  - `HabitOperationSuccess`: Operation completed successfully
  - `HabitError`: Error occurred

#### Data Model
```dart
class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String category;
  final String frequency; // daily, weekly, monthly
  final int targetCount;
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime? reminderTime;
  final List<DateTime> completedDates;
  final Map<String, dynamic> metadata;
}
```

#### Repository Methods
- `getHabitsStream()`: Real-time stream of habits
- `getHabits()`: One-time fetch of all habits
- `getHabitById(String id)`: Get specific habit
- `addHabit(HabitModel)`: Create new habit
- `updateHabit(HabitModel)`: Update habit
- `deleteHabit(String id)`: Remove habit
- `completeHabit(String id)`: Mark as completed
- `toggleHabitActive(String id)`: Toggle active status

### 2. Task Management

#### Overview
Organize tasks with priorities, deadlines, and status tracking.

#### Key Features
- **Create Tasks**: Add tasks with title, description, priority, and due date
- **Priority Levels**: High, Medium, Low
- **Status Tracking**: Pending, In Progress, Completed
- **Due Date Management**: Set and track task deadlines
- **Overdue Detection**: Automatically identify overdue tasks
- **Categories**: Organize tasks by custom categories
- **Tab Navigation**: Quick access to tasks by status
- **Statistics**: View total, pending, completed, and overdue tasks

#### BLoC Components
- **Events**:
  - `TaskLoadRequested`: Load all tasks
  - `TaskAddRequested`: Add new task
  - `TaskUpdateRequested`: Update task
  - `TaskDeleteRequested`: Delete task
  - `TaskCompleteRequested`: Mark as completed
  - `TaskStatusUpdateRequested`: Update task status
  - `TaskFilterChanged`: Apply filters

- **States**:
  - `TaskInitial`: Initial state
  - `TaskLoading`: Loading tasks
  - `TaskLoaded`: Tasks successfully loaded with categorization
  - `TaskOperationInProgress`: Operation in progress
  - `TaskOperationSuccess`: Operation completed
  - `TaskError`: Error occurred

#### Data Model
```dart
class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String priority; // high, medium, low
  final String status; // pending, in_progress, completed
  final String category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringPattern;
  final Map<String, dynamic> metadata;
}
```

#### Repository Methods
- `getTasksStream()`: Real-time stream of tasks
- `getTasks()`: One-time fetch of all tasks
- `getTaskById(String id)`: Get specific task
- `addTask(TaskModel)`: Create new task
- `updateTask(TaskModel)`: Update task
- `deleteTask(String id)`: Remove task
- `completeTask(String id)`: Mark as completed
- `updateTaskStatus(String id, String status)`: Change status
- `getTasksByStatus(String status)`: Filter by status
- `getOverdueTasks()`: Get overdue tasks

### 3. Expense Management

#### Overview
Track spending, categorize expenses, and monitor budgets.

#### Key Features
- **Record Expenses**: Add expenses with amount, category, and payment method
- **Categories**: Food & Dining, Transportation, Shopping, Entertainment, Bills & Utilities, Healthcare, Education, Travel, Other
- **Payment Methods**: Cash, Card, Digital
- **Statistics**: Today, Week, Month totals
- **Date Grouping**: Expenses organized by date
- **Category Filtering**: Filter by expense category
- **Analytics**: Category-wise spending breakdown
- **Receipt Tracking**: Optional receipt image URL storage

#### BLoC Components
- **Events**:
  - `ExpenseLoadRequested`: Load all expenses
  - `ExpenseAddRequested`: Add new expense
  - `ExpenseUpdateRequested`: Update expense
  - `ExpenseDeleteRequested`: Delete expense
  - `ExpenseFilterByDateRequested`: Filter by date range
  - `ExpenseFilterByCategoryRequested`: Filter by category

- **States**:
  - `ExpenseInitial`: Initial state
  - `ExpenseLoading`: Loading expenses
  - `ExpenseLoaded`: Expenses loaded with statistics
  - `ExpenseOperationInProgress`: Operation in progress
  - `ExpenseOperationSuccess`: Operation completed
  - `ExpenseError`: Error occurred

#### Data Model
```dart
class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? receiptImageUrl;
  final String? location;
  final String paymentMethod; // cash, card, digital
  final List<String> tags;
  final Map<String, dynamic> metadata;
}
```

#### Repository Methods
- `getExpensesStream()`: Real-time stream of expenses
- `getExpenses()`: One-time fetch of all expenses
- `getExpenseById(String id)`: Get specific expense
- `addExpense(ExpenseModel)`: Create new expense
- `updateExpense(ExpenseModel)`: Update expense
- `deleteExpense(String id)`: Remove expense
- `getExpensesByCategory(String category)`: Filter by category
- `getExpensesByDateRange(DateTime start, DateTime end)`: Filter by date
- `getTodayExpenses()`: Get today's expenses
- `getWeekExpenses()`: Get this week's expenses
- `getMonthExpenses()`: Get this month's expenses
- `getCategoryTotals()`: Calculate category-wise totals

## Firebase Configuration

### Firestore Collections

#### Habits Collection
```
habits/
  {habitId}/
    - id: String
    - userId: String
    - name: String
    - description: String
    - category: String
    - frequency: String
    - targetCount: Number
    - currentStreak: Number
    - longestStreak: Number
    - createdAt: Timestamp
    - updatedAt: Timestamp
    - isActive: Boolean
    - reminderTime: Timestamp (optional)
    - completedDates: Array<Timestamp>
    - metadata: Map
```

#### Tasks Collection
```
tasks/
  {taskId}/
    - id: String
    - userId: String
    - title: String
    - description: String
    - priority: String
    - status: String
    - category: String
    - dueDate: Timestamp (optional)
    - createdAt: Timestamp
    - updatedAt: Timestamp
    - completedAt: Timestamp (optional)
    - tags: Array<String>
    - isRecurring: Boolean
    - recurringPattern: String (optional)
    - metadata: Map
```

#### Expenses Collection
```
expenses/
  {expenseId}/
    - id: String
    - userId: String
    - amount: Number
    - category: String
    - description: String
    - date: Timestamp
    - createdAt: Timestamp
    - updatedAt: Timestamp
    - receiptImageUrl: String (optional)
    - location: String (optional)
    - paymentMethod: String
    - tags: Array<String>
    - metadata: Map
```

### Firestore Indexes
Required indexes for optimal query performance:
- `habits`: userId (ascending) + createdAt (descending)
- `tasks`: userId (ascending) + createdAt (descending)
- `expenses`: userId (ascending) + date (descending)

## Dependencies

### Core Dependencies
- `flutter_bloc: ^9.1.1` - State management
- `equatable: ^2.0.5` - Value equality
- `go_router: ^16.2.4` - Navigation
- `uuid: ^4.5.1` - Unique ID generation

### Firebase
- `firebase_core: ^4.1.1`
- `firebase_auth: ^6.1.0`
- `cloud_firestore: ^6.0.2`
- `firebase_storage: ^13.0.2`
- `firebase_messaging: ^16.0.2`

### Storage & Data
- `hive: ^2.2.3` - Local storage
- `hive_flutter: ^1.1.0`
- `shared_preferences: ^2.3.2`

### Utilities
- `intl: ^0.20.2` - Internationalization and formatting
- `fl_chart: ^1.1.1` - Charts and graphs

## Usage Examples

### Adding a Habit
```dart
final habit = HabitModel(
  id: const Uuid().v4(),
  userId: currentUserId,
  name: 'Morning Exercise',
  description: '30 minutes of cardio',
  category: 'Fitness',
  frequency: 'daily',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

context.read<HabitBloc>().add(HabitAddRequested(habit: habit));
```

### Adding a Task
```dart
final task = TaskModel(
  id: const Uuid().v4(),
  userId: currentUserId,
  title: 'Complete project report',
  description: 'Write and submit the quarterly report',
  priority: 'high',
  category: 'Work',
  dueDate: DateTime.now().add(Duration(days: 3)),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

context.read<TaskBloc>().add(TaskAddRequested(task: task));
```

### Adding an Expense
```dart
final expense = ExpenseModel(
  id: const Uuid().v4(),
  userId: currentUserId,
  amount: 45.99,
  category: 'Food & Dining',
  description: 'Lunch at restaurant',
  date: DateTime.now(),
  paymentMethod: 'card',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

context.read<ExpenseBloc>().add(ExpenseAddRequested(expense: expense));
```

## Best Practices

### Code Organization
1. **Separation of Concerns**: Keep business logic in BLoC, UI in widgets
2. **Reusability**: Create reusable widgets for common UI patterns
3. **Documentation**: Document all public methods and classes
4. **Type Safety**: Use strong typing throughout the codebase
5. **Error Handling**: Proper try-catch blocks in repositories

### State Management
1. **Immutable States**: All state classes use `const` constructors
2. **Event-driven**: User actions trigger events, not direct state changes
3. **Single Responsibility**: Each BLoC handles one feature domain
4. **Stream Subscriptions**: Properly dispose of subscriptions in BLoC close()

### Firebase Best Practices
1. **Batch Operations**: Use batch writes for multiple updates
2. **Indexes**: Create indexes for frequently queried fields
3. **Security Rules**: Implement proper Firestore security rules
4. **Offline Support**: Leverage Firestore offline persistence
5. **Query Limits**: Limit query results for better performance

## Testing

### Unit Tests
- Test BLoC event handlers
- Test repository methods
- Test model serialization/deserialization

### Widget Tests
- Test screen rendering
- Test user interactions
- Test state changes

### Integration Tests
- Test complete user flows
- Test Firebase integration
- Test navigation

## Future Enhancements

### Planned Features
1. **Analytics Dashboard**: Visual charts and insights
2. **Notifications**: Reminders for habits and tasks
3. **Data Export**: Export data to CSV/PDF
4. **Recurring Tasks**: Automatic task creation based on patterns
5. **Budget Management**: Set and track spending budgets
6. **Goal Setting**: Long-term goal tracking
7. **Social Features**: Share progress with friends
8. **AI Insights**: Smart suggestions based on user behavior

### Technical Improvements
1. **Offline Mode**: Enhanced offline functionality
2. **Performance**: Query optimization and caching
3. **Accessibility**: Improved accessibility features
4. **Localization**: Multi-language support
5. **Dark Mode**: Complete dark theme implementation

## Support

For issues, questions, or contributions, please refer to the main README.md file.

## License

This project is part of the SmartLife app ecosystem.

