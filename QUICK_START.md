# 🚀 Quick Start Guide

## Getting the App Running

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Database Code
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## 📱 Using the App

### Home Screen
- Beautiful cards showing all 5 database types
- Tap any card to see its demo
- Each card shows use cases and when to use that database

### SharedPreferences Demo
- ✏️ **Edit Username:** Type in the text field and press Enter
- 🔢 **Login Count:** Click "Simulate Login" to increment
- 🌙 **Dark Mode:** Toggle the switch
- 📏 **Font Size:** Drag the slider
- 🗑️ **Clear All:** Tap the delete icon in app bar

### Hive Demo
- ➕ **Add Note:** Fill title, content, select category, then tap "Add"
- ✏️ **Edit Note:** Tap the edit icon on any note
- 🗑️ **Delete Note:** Tap the delete icon
- 📊 **View Stats:** Check the bottom bar for category breakdown
- 🎨 **Categories:** Personal (blue), Work (green), Ideas (purple), Shopping (orange)

### SQFlite Demo
- 💰 **Add Expense:** Enter title, amount, select category, add description
- ✏️ **Edit Expense:** Tap the three dots menu → Edit
- 🗑️ **Delete Expense:** Tap the three dots menu → Delete
- 📊 **View Summary:** See total and category breakdown in the card
- 💳 **Categories:** Food, Transport, Shopping, Entertainment, Bills, Healthcare, Other

### Drift Demo
- ✅ **Add Todo:** Fill title, description, set priority, optionally set due date
- ☑️ **Toggle Complete:** Tap the checkbox
- ✏️ **Edit Todo:** Long press on any todo card
- 🚩 **Priority Levels:** Low (green), Medium (orange), High (red)
- 📅 **Due Dates:** Shows "Today", "Tomorrow", or actual date
- ⚠️ **Overdue:** Overdue tasks show in red background
- 🗑️ **Clear Completed:** Tap the sweep icon in app bar
- 📊 **View Stats:** Bottom bar shows total, pending, done, and completion rate

### ObjectBox Demo
- 📦 **Add Product:** Enter name, SKU, price, quantity, select category
- 🛒 **Add Samples:** Tap shopping cart icon for quick sample data
- ✏️ **Edit Product:** Expand card and tap "Edit" button
- 🗑️ **Delete Product:** Expand card and tap "Delete" button
- 📊 **View Stats:** See total products, inventory value, and low stock count
- 🔍 **Filter:** Use chips to filter by category or low stock
- ➕➖ **Adjust Stock:** Use +/- buttons in expanded card
- ⚠️ **Low Stock Alert:** Products with < 10 units show warning badge
- 🎨 **Categories:** Electronics, Clothing, Food, Books, Home, Sports, Toys

## 🎯 Tips

1. **Try Each Database:** Explore each demo to understand the differences
2. **Notice Reactivity:** In Hive and Drift, UI updates automatically when data changes
3. **Compare Code:** Check the source files to see implementation differences
4. **Test Persistence:** Close and reopen the app - all data persists!
5. **Performance:** Notice how fast Hive operations are compared to SQL databases

## 🔧 Troubleshooting

### If you get build errors:
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### If database isn't working:
- Uninstall the app from device/emulator
- Reinstall fresh

### If Hive errors occur:
- Check that build_runner generated `note.g.dart`
- Make sure Hive is initialized in `main.dart`

### If Drift errors occur:
- Check that `drift_database.g.dart` exists
- Verify schema version matches

## 📖 Learn More

- Each screen has inline documentation
- Check the model files to see data structures
- Review service files for database operations
- Read comments in the code for explanations

## 🎓 Next Steps

After exploring the demos:

1. **Experiment:** Try adding new features to each demo
2. **Benchmark:** Add timing code to compare performance
3. **Extend:** Add more fields or functionality
4. **Combine:** Try using multiple databases in one feature
5. **Build Your Own:** Create a new app using the database that fits your needs

## 💡 Key Takeaways

| Database | Best For | Speed | Complexity | Demo Type |
|----------|----------|-------|------------|-----------|
| SharedPreferences | Simple settings | ⚡⚡⚡ | ⭐ | User Preferences |
| Hive | Offline caching | ⚡⚡⚡ | ⭐⭐ | Note Taking |
| ObjectBox | Heavy data | ⚡⚡⚡⚡ | ⭐⭐⭐ | Inventory System |
| SQFlite | Relational data | ⚡⚡ | ⭐⭐⭐ | Expense Tracker |
| Drift | Reactive + SQL | ⚡⚡ | ⭐⭐⭐⭐ | Todo Manager |

**Happy Learning! 🚀**

