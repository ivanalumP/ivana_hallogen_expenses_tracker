# Flutter Project

A Flutter application for tracking personal expenses with a  Clean Architecture principles, 
BLoC pattern for state management, and dependency injection.

## 🚀 Features

### Core Functionality
- **Expense Management**: Add, edit, and track personal expenses
- **Budget Tracking**: Set monthly budgets and monitor spending
- **Category Management**: Organize expenses by categories with recommended percentages
- **Expense Records**: View and filter expense history
- **Budget Summary**: Visual overview of spending patterns and remaining budget

### User Experience
- **Modern UI**: Material Design 3 with custom gradients and themes
- **Intuitive Navigation**: Bottom navigation with 4 main tabs
- **Form Validation**: Real-time validation for expense forms
- **Sorting & Filtering**: Organize expenses by date, amount, and category

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **BLoC pattern** for state management:

```
lib/
├── main.dart                           # App entry point with DI setup
├── dependencyInjection/                # Service locator configuration
│   └── service_locator.dart           # GetIt dependency injection setup
├── core/                              # Core utilities and helpers
│   ├── helpers/                       # Helper functions
│   │   └── category_helpers.dart      # Category color and icon utilities
│   └── router/                        # Navigation routing
│       ├── app_router.dart            # AutoRoute configuration
│       └── app_router.gr.dart         # Generated route code
├── domain/                            # Business logic layer
│   └── repositories/                  # Repository interfaces
│       └── expense_category_repository.dart
├── data/                              # Data layer
│   ├── models/                        # Data models with JSON serialization
│   │   ├── expense.dart               # Expense entity
│   │   ├── budget.dart                # Budget entity
│   │   ├── expense_category.dart      # Category entity
│   │   └── api_response.dart          # API response wrapper
│   └── repositories/                  # Repository implementations
│       └── expense_category_repository_impl.dart
├── services/                          # Business services
│   ├── expense_category_service.dart  # Category API service
│   ├── hive_storage_service.dart      # Local storage service
│   └── navigation_service.dart        # Navigation utilities
└── presentation/                      # UI layer
    ├── screens/                       # Application screens
    │   ├── main_screen.dart           # Main screen with bottom navigation
    │   ├── main_tab.dart              # Budget overview and summary
    │   ├── records_tab.dart           # Expense records with filtering
    │   ├── recommended_tab.dart       # Recommended categories
    │   └── add_expenses_screen.dart   # Add new expense form
    ├── blocs/                         # State management (BLoC/Cubit)
    │   ├── add_expense_form_cubit.dart        # Form state management
    │   ├── add_expense_category_cubit.dart    # Category fetching
    │   ├── budget_cubit.dart                  # Budget calculations
    │   ├── expense_cubit.dart                 # Expense CRUD operations
    │   ├── expense_category_cubit.dart        # Category state
    │   ├── navigation_cubit.dart              # Navigation state
    │   ├── recommended_cubit.dart             # Recommendations
    │   └── expense_category_state.dart        # Category states
    ├── widgets/                       # Reusable UI components
    │   ├── base_screen.dart           # Base screen wrapper
    │   ├── budget_edit_dialog.dart    # Budget editing dialog
    │   ├── budget_summary.dart        # Budget overview widget
    │   ├── expense_category_item.dart # Category list item
    │   └── expense_item.dart          # Expense list item
    └── theme/                         # UI theming
        ├── custom_gradient_theme.dart # Custom gradient theme
        └── theme_constants.dart       # Theme constants
```

## 📱 Screens & Navigation

### Main Screen (`main_screen.dart`)
- **Bottom Navigation**: 4 main tabs with smooth transitions
- **NavigationCubit**: Manages active tab state

### Main Tab (`main_tab.dart`)
- **Budget Summary**: Monthly budget overview with progress indicators
- **Current Balance**: Real-time balance calculation
- **Total Spent**: Cumulative spending display
- **BudgetCubit**: Manages budget calculations and updates

### Records Tab (`records_tab.dart`)
- **Expense List**: Chronological list of all expenses
- **Sorting Options**: Sort by date, amount, or category
- **Category Filtering**: Filter expenses by specific categories
- **Summary Statistics**: Filtered totals and counts
- **ExpenseCubit**: Manages expense data and operations

### Recommended Tab (`recommended_tab.dart`)
- **Category Recommendations**: Suggested spending percentages
- **Fixed vs Flexible**: Distinguish between fixed and variable expenses
- **Visual Indicators**: Color-coded categories with icons
- **RecommendedCubit**: Manages recommendation data

### Add Expenses Screen (`add_expenses_screen.dart`)
- **Form Validation**: Real-time validation for required fields
- **Category Selection**: Dropdown with available categories
- **Amount Input**: Numeric input with validation
- **Date Picker**: Calendar date selection
- **Notes Field**: Optional expense description
- **AddExpenseFormCubit**: Manages form state and validation
- **AddExpenseCategoryCubit**: Fetches and manages categories

## 🔧 Dependencies

### Core Dependencies
- **Flutter SDK** ^3.2.3 - Cross-platform UI framework
- **flutter_bloc** ^8.1.3 - State management with BLoC pattern
- **equatable** ^2.0.5 - Value equality for immutable objects
- **get_it** ^7.6.4 - Dependency injection service locator

### Data & Storage
- **dio** ^5.3.2 - HTTP client for API requests
- **hive** ^2.2.3 - Local NoSQL database
- **hive_flutter** ^1.1.0 - Flutter integration for Hive
- **json_annotation** ^4.8.1 - JSON serialization support

### Navigation & UI
- **auto_route** ^7.8.4 - Declarative routing solution

### Development Dependencies
- **bloc_test** ^9.1.5 - Testing utilities for BLoC
- **mockito** ^5.4.4 - Mocking framework for testing
- **build_runner** ^2.4.6 - Code generation
- **json_serializable** ^6.7.1 - JSON code generation
- **hive_generator** ^2.0.1 - Hive code generation

## 🌐 API Integration

The app fetches expense categories from:
```
GET https://media.halogen.my/experiment/mobile/expenseCategories.json
```

### Local Storage
- **Hive Database**: Stores expenses, budgets, and categories locally
- **Offline Support**: App works without internet connection
- **Data Persistence**: Data survives app restarts

## 🎯 State Management

### BLoC Pattern Implementation
- **Cubits**: Lightweight state management for simple scenarios
- **State Classes**: Immutable state objects with Equatable
- **Event Handling**: Structured approach to state changes
- **Lifecycle Management**: Proper disposal and cleanup

### Key Cubits
1. **BudgetCubit**: Manages budget calculations and updates
2. **ExpenseCubit**: Handles expense CRUD operations
3. **AddExpenseFormCubit**: Manages form state and validation
4. **AddExpenseCategoryCubit**: Fetches and caches categories
5. **NavigationCubit**: Manages bottom navigation state
6. **RecommendedCubit**: Handles category recommendations

## 🧪 Testing
- **BLoC Tests**: State emission and transition testing
- **Mock Testing**: Isolated testing with Mockito

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.2.3
- Dart SDK ^3.2.3
- Android Studio / VS Code with Flutter extensions

### Data Management
- **Local Storage**: Hive database for offline functionality
- **Data Export**: Future CSV/PDF export capabilities
- **Backup & Sync**: Cloud synchronization (planned)
- **Data Migration**: Version upgrade support

## 📚 Documentation
- **Code Comments**: Comprehensive inline documentation
