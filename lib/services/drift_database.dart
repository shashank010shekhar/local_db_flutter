import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

/// Drift Table Definition for Todos
/// 
/// This class defines the schema for the todos table
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(1))(); // 1=Low, 2=Medium, 3=High
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
}

/// Drift Database Configuration
/// 
/// This class manages the database connection and provides
/// reactive queries using Streams
@DriftDatabase(tables: [Todos])
class DriftDB extends _$DriftDB {
  DriftDB() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ============ CRUD Operations ============

  /// Get all todos as a stream (reactive)
  Stream<List<Todo>> watchAllTodos() => select(todos).watch();

  /// Get todos by completion status
  Stream<List<Todo>> watchTodosByStatus(bool completed) {
    return (select(todos)
          ..where((t) => t.isCompleted.equals(completed))
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.createdAt),
          ]))
        .watch();
  }

  /// Get todos by priority
  Stream<List<Todo>> watchTodosByPriority(int priority) {
    return (select(todos)
          ..where((t) => t.priority.equals(priority))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch();
  }

  /// Get a single todo by ID
  Stream<Todo> watchTodoById(int id) {
    return (select(todos)..where((t) => t.id.equals(id))).watchSingle();
  }

  /// Get all todos (one-time query)
  Future<List<Todo>> getAllTodos() => select(todos).get();

  /// Insert a new todo
  Future<int> insertTodo(TodosCompanion todo) {
    return into(todos).insert(todo);
  }

  /// Update a todo
  Future<bool> updateTodo(Todo todo) {
    return update(todos).replace(todo);
  }

  /// Toggle todo completion status
  Future<int> toggleTodoCompletion(int id, bool isCompleted) {
    return (update(todos)..where((t) => t.id.equals(id)))
        .write(TodosCompanion(isCompleted: Value(isCompleted)));
  }

  /// Delete a todo
  Future<int> deleteTodo(int id) {
    return (delete(todos)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all completed todos
  Future<int> deleteCompletedTodos() {
    return (delete(todos)..where((t) => t.isCompleted.equals(true))).go();
  }

  /// Delete all todos
  Future<int> deleteAllTodos() {
    return delete(todos).go();
  }

  // ============ Statistics ============

  /// Get count of todos by status
  Future<int> getTodoCount({bool? completed}) async {
    final query = selectOnly(todos)..addColumns([todos.id.count()]);
    
    if (completed != null) {
      query.where(todos.isCompleted.equals(completed));
    }
    
    final result = await query.getSingle();
    return result.read(todos.id.count()) ?? 0;
  }

  /// Get todos grouped by priority
  Future<Map<int, int>> getTodoCountByPriority() async {
    final query = selectOnly(todos)
      ..addColumns([todos.priority, todos.id.count()])
      ..groupBy([todos.priority]);

    final results = await query.get();
    return {
      for (var row in results)
        row.read(todos.priority)!: row.read(todos.id.count()) ?? 0
    };
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todos_drift.sqlite'));
    return NativeDatabase(file);
  });
}

