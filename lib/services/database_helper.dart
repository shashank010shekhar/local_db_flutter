import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

/// SQFlite Database Helper
/// 
/// Demonstrates:
/// - Creating and managing SQLite database
/// - SQL table schema definition
/// - CRUD operations with SQL queries
/// - Transaction handling
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE expenses (
        id $idType,
        title $textType,
        amount $realType,
        category $textType,
        date $textType,
        description TEXT
      )
    ''');
  }

  /// Create (Insert) a new expense
  Future<int> createExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  /// Read (Query) all expenses
  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    const orderBy = 'date DESC';
    
    final result = await db.query('expenses', orderBy: orderBy);
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  /// Read expense by ID
  Future<Expense?> getExpenseById(int id) async {
    final db = await database;
    
    final maps = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    }
    return null;
  }

  /// Get expenses by category
  Future<List<Expense>> getExpensesByCategory(String category) async {
    final db = await database;
    
    final result = await db.query(
      'expenses',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  /// Get expenses within date range
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    
    final result = await db.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  /// Get total expense amount
  Future<double> getTotalExpenses() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    final total = result.first['total'];
    return total != null ? total as double : 0.0;
  }

  /// Get total by category
  Future<Map<String, double>> getTotalByCategory() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM expenses GROUP BY category'
    );

    final Map<String, double> categoryTotals = {};
    for (var row in result) {
      categoryTotals[row['category'] as String] = row['total'] as double;
    }
    return categoryTotals;
  }

  /// Update an expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all expenses (clear table)
  Future<int> deleteAllExpenses() async {
    final db = await database;
    return await db.delete('expenses');
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

