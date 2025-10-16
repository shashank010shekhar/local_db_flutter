# 🗄️ Flutter Local Databases Demo

**Day 1 of 100 Days, 100 Concepts — Mastering Dart & Flutter the Right Way!**

A comprehensive demonstration of 5 different local database solutions in Flutter, helping you understand when, why, and how to use each one.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📚 What's Inside

This project showcases **5 local database solutions** with fully functional demo screens:

### 1️⃣ SharedPreferences
**Simple Key-Value Store**
- ✅ Store user preferences (username, theme, settings)
- ✅ Supports: String, int, bool, double, List<String>
- ✅ Best for: Small amounts of simple data
- ✅ Demo: User preferences manager

**Use Cases:** Login state, app theme, language preference

### 2️⃣ Hive
**Pure Dart NoSQL Database**
- ✅ Fast, lightweight, and offline-friendly
- ✅ No native dependencies required
- ✅ Type adapters for custom objects
- ✅ Demo: Note-taking app with categories

**Use Cases:** Caching API data, chat messages, local app states

### 3️⃣ SQFlite
**SQLite for Flutter**
- ✅ Full SQL control with queries
- ✅ Relational database structure
- ✅ CRUD operations with transactions
- ✅ Demo: Expense tracker with analytics

**Use Cases:** Expense trackers, inventory systems, contact managers

### 4️⃣ Drift (formerly Moor)
**Reactive ORM for SQLite**
- ✅ Type-safe SQL queries
- ✅ Reactive streams for real-time UI updates
- ✅ Auto-generated code
- ✅ Demo: Todo app with priorities and due dates

**Use Cases:** Todo apps, notes apps, apps requiring reactive UI updates

### 5️⃣ ObjectBox
**High-Performance Object Database**
- ✅ Blazing fast (10x faster than SQLite)
- ✅ Object-oriented approach
- ✅ Complex queries and filtering
- ✅ Demo: Inventory management system

**Use Cases:** IoT dashboards, analytics, real-time data tracking, e-commerce

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd local_db_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code for Hive and Drift**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point with ObjectBox init
├── objectbox.g.dart              # Generated ObjectBox code
├── objectbox-model.json          # ObjectBox schema
├── screens/
│   ├── home_screen.dart          # Main navigation screen
│   ├── shared_prefs_screen.dart  # SharedPreferences demo
│   ├── hive_screen.dart          # Hive demo
│   ├── objectbox_screen.dart     # ObjectBox demo
│   ├── sqflite_screen.dart       # SQFlite demo
│   └── drift_screen.dart         # Drift demo
├── models/
│   ├── note.dart                 # Hive model with adapter
│   ├── expense.dart              # SQFlite model
│   └── product.dart              # ObjectBox entity
└── services/
    ├── database_helper.dart      # SQFlite database helper
    ├── drift_database.dart       # Drift database configuration
    └── objectbox_service.dart    # ObjectBox store service
```

## 🎯 Features by Database

### SharedPreferences Demo
- [x] Store and retrieve strings
- [x] Store and retrieve integers
- [x] Store and retrieve booleans
- [x] Store and retrieve doubles
- [x] Clear all preferences
- [x] Real-time UI updates

### Hive Demo
- [x] Add notes with title, content, and category
- [x] Edit existing notes
- [x] Delete notes
- [x] Real-time updates with ValueListenableBuilder
- [x] Category-based organization
- [x] Statistics dashboard

### SQFlite Demo
- [x] Add expenses with categories
- [x] Edit and delete expenses
- [x] SQL queries for filtering
- [x] Aggregate queries (SUM, GROUP BY)
- [x] Category-wise expense breakdown
- [x] Date-based sorting

### Drift Demo
- [x] Add todos with priorities
- [x] Set due dates
- [x] Mark as complete/incomplete
- [x] Edit todos
- [x] Reactive UI with streams
- [x] Automatic UI updates on data changes
- [x] Overdue task highlighting
- [x] Completion statistics

### ObjectBox Demo
- [x] Add products with details (name, SKU, price, quantity)
- [x] Edit and delete products
- [x] Category-based filtering
- [x] Low stock alerts
- [x] Real-time inventory value calculation
- [x] Batch operations (add sample products)
- [x] Stock increase/decrease controls
- [x] Complex queries (by category, stock status)

## 🧠 Choosing the Right Database

| Use Case | Recommended DB |
|----------|----------------|
| **Small preferences** | SharedPreferences |
| **Fast local caching** | Hive |
| **Heavy data with objects** | ObjectBox |
| **Relational data** | SQFlite |
| **Reactive + Relational** | Drift |

### Decision Matrix

**Use SharedPreferences when:**
- You need to store simple key-value pairs
- Data is less than a few KB
- No complex queries needed

**Use Hive when:**
- You need fast local storage
- Working with objects/models
- No complex relationships between data
- Want pure Dart solution (no native code)

**Use SQFlite when:**
- You need relational database features
- Complex queries with JOINs
- Data has clear relationships
- SQL expertise in team

**Use Drift when:**
- You want SQFlite benefits + reactivity
- Need type-safe queries
- Want automatic UI updates
- Prefer code generation over manual SQL

**Use ObjectBox when:**
- Handling massive datasets
- Need maximum performance
- Frequent read/write operations
- Can handle native setup

## 📦 Dependencies

```yaml
dependencies:
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  objectbox: ^4.0.3
  objectbox_flutter_libs: ^4.0.3

dev_dependencies:
  hive_generator: ^2.0.1
  drift_dev: ^2.14.1
  build_runner: ^2.4.7
  objectbox_generator: ^4.0.3
```

## 🎨 UI Features

- ✨ Beautiful Material 3 design
- 🎨 Gradient backgrounds
- 📱 Responsive layout
- 🌗 Dark mode support
- 💫 Smooth animations
- 📊 Visual statistics and charts
- 🎯 Intuitive navigation

## 📝 Code Generation

This project uses code generation for:
- **Hive:** Type adapters for models
- **Drift:** Database tables and queries

To regenerate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:
```bash
dart run build_runner watch
```

## 🔍 Key Learnings

### SharedPreferences
- Perfect for simple persistent settings
- Limited to primitive types
- Fast synchronous access after initial load
- Platform-specific implementation (UserDefaults on iOS, SharedPreferences on Android)

### Hive
- Blazing fast binary storage
- Type adapters enable custom object storage
- No SQL knowledge required
- Great for offline-first apps
- ValueListenableBuilder for reactive UI

### ObjectBox
- Native performance with C++ core
- Object-oriented database (no SQL needed)
- Extremely fast for large datasets
- Built-in query builder
- Reactive queries with streams
- Perfect for IoT and real-time apps

### SQFlite
- Industry-standard SQLite
- Full SQL capabilities
- Excellent for complex queries
- Mature ecosystem
- Manual schema management

### Drift
- Best of both worlds: SQL + Dart
- Compile-time query validation
- Automatic code generation
- Stream-based reactivity
- Built on top of SQFlite

## 🐛 Troubleshooting

### Build Runner Issues
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Database Migration
When changing Drift or SQFlite schemas, you may need to:
1. Uninstall the app
2. Clear app data
3. Increment schema version

## 📖 Resources

- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Hive Documentation](https://docs.hivedb.dev/)
- [SQFlite Documentation](https://pub.dev/packages/sqflite)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [ObjectBox Documentation](https://docs.objectbox.io/)

## 🤝 Contributing

Feel free to contribute! This is part of my 100 Days of Flutter journey.

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**100 Days of Flutter Challenge**

Day 1: Local Databases Mastery ✅

---

## 🎯 Next Steps

After understanding these databases, consider:
- Implementing database migrations
- Adding encryption for sensitive data
- Benchmarking performance
- Implementing data synchronization
- Exploring hybrid approaches

## 💡 Tips

1. **Start Simple:** Use SharedPreferences for simple needs
2. **Profile Performance:** Test with real-world data volumes
3. **Plan Schema:** Design database structure before coding
4. **Handle Errors:** Always wrap database operations in try-catch
5. **Test Thoroughly:** Write unit tests for database operations

---

**Happy Coding! 🚀**

If you found this helpful, consider:
- ⭐ Starring the repository
- 🔄 Sharing with others
- 💬 Providing feedback
- 🐛 Reporting issues

#Flutter #MobileDevelopment #Databases #Hive #SQLite #Drift #100DaysOfCode
