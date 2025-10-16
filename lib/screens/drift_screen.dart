import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../services/drift_database.dart';

/// Drift (Moor) Demo Screen
/// 
/// Demonstrates:
/// - Reactive database with streams
/// - Type-safe SQL queries
/// - Auto-updating UI when data changes
/// - Complex queries with ordering and filtering
class DriftScreen extends StatefulWidget {
  const DriftScreen({super.key});

  @override
  State<DriftScreen> createState() => _DriftScreenState();
}

class _DriftScreenState extends State<DriftScreen> {
  late DriftDB database;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _selectedPriority = 1;
  DateTime? _selectedDueDate;
  
  final List<String> _priorityLabels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    database = DriftDB();
  }

  /// Add a new todo
  Future<void> _addTodo() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final todo = TodosCompanion(
      title: drift.Value(_titleController.text),
      description: drift.Value(_descriptionController.text.isEmpty 
          ? null 
          : _descriptionController.text),
      isCompleted: const drift.Value(false),
      priority: drift.Value(_selectedPriority),
      createdAt: drift.Value(DateTime.now()),
      dueDate: drift.Value(_selectedDueDate),
    );

    await database.insertTodo(todo);

    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedPriority = 1;
      _selectedDueDate = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo added!')),
      );
    }
  }

  /// Toggle todo completion
  Future<void> _toggleTodo(Todo todo) async {
    await database.toggleTodoCompletion(todo.id, !todo.isCompleted);
  }


  /// Clear completed todos
  Future<void> _clearCompleted() async {
    final count = await database.deleteCompletedTodos();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted $count completed todos')),
      );
    }
  }

  /// Show edit dialog
  void _showEditDialog(Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description ?? '');
    int priority = todo.priority;
    DateTime? dueDate = todo.dueDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: [1, 2, 3]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(_priorityLabels[p - 1]),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => priority = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(dueDate == null
                      ? 'No due date'
                      : 'Due: ${_formatDate(dueDate!)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setDialogState(() => dueDate = date);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final updated = Todo(
                    id: todo.id,
                    title: titleController.text,
                    description: descController.text.isEmpty ? null : descController.text,
                    isCompleted: todo.isCompleted,
                    priority: priority,
                    createdAt: todo.createdAt,
                    dueDate: dueDate,
                  );
                  await database.updateTodo(updated);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// Select due date
  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDueDate = date);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drift - Reactive ORM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearCompleted,
            tooltip: 'Clear completed',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoCard(),
          _buildInputSection(),
          const Divider(height: 1),
          Expanded(child: _buildTodosList()),
          _buildStatsBar(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.purple.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.sync_alt, color: Colors.purple.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drift - Reactive SQL ORM',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type-safe queries with real-time reactive updates',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Todo Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.task),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.priority_high),
                  ),
                  items: [1, 2, 3]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: _getPriorityColor(p),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(_priorityLabels[p - 1]),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPriority = value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDueDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDueDate == null
                        ? 'Due Date'
                        : _formatDate(_selectedDueDate!),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addTodo,
              icon: const Icon(Icons.add),
              label: const Text('Add Todo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodosList() {
    return StreamBuilder<List<Todo>>(
      stream: database.watchAllTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No todos yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first todo above',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ],
            ),
          );
        }

        final todos = snapshot.data!;
        final pending = todos.where((t) => !t.isCompleted).toList();
        final completed = todos.where((t) => t.isCompleted).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (pending.isNotEmpty) ...[
              _buildSectionHeader('Pending (${pending.length})'),
              ...pending.map((todo) => _buildTodoCard(todo)),
            ],
            if (completed.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionHeader('Completed (${completed.length})'),
              ...completed.map((todo) => _buildTodoCard(todo)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo) {
    final priorityColor = _getPriorityColor(todo.priority);
    final isOverdue = todo.dueDate != null && 
        todo.dueDate!.isBefore(DateTime.now()) && 
        !todo.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverdue ? Colors.red.shade50 : null,
      child: InkWell(
        onLongPress: () => _showEditDialog(todo),
        borderRadius: BorderRadius.circular(12),
        child: CheckboxListTile(
          value: todo.isCompleted,
          onChanged: (_) => _toggleTodo(todo),
          contentPadding: const EdgeInsets.all(16),
          secondary: Icon(
            Icons.flag,
            color: priorityColor,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description != null && todo.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  todo.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    color: todo.isCompleted ? Colors.grey : null,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Chip(
                    label: Text(
                      _priorityLabels[todo.priority - 1],
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: priorityColor.withOpacity(0.2),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  if (todo.dueDate != null)
                    Chip(
                      avatar: Icon(
                        isOverdue ? Icons.warning : Icons.calendar_today,
                        size: 14,
                        color: isOverdue ? Colors.red : Colors.blue,
                      ),
                      label: Text(
                        _formatDate(todo.dueDate!),
                        style: TextStyle(
                          fontSize: 11,
                          color: isOverdue ? Colors.red : null,
                        ),
                      ),
                      backgroundColor: isOverdue
                          ? Colors.red.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          tristate: false,
          isThreeLine: todo.description != null && todo.description!.isNotEmpty,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return StreamBuilder<List<Todo>>(
      stream: database.watchAllTodos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final todos = snapshot.data!;
        final total = todos.length;
        final completed = todos.where((t) => t.isCompleted).length;
        final pending = total - completed;
        final completionRate = total > 0 ? (completed / total * 100).toStringAsFixed(0) : '0';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem('Total', total.toString(), Icons.list, Colors.blue),
              ),
              Expanded(
                child: _buildStatItem('Pending', pending.toString(), Icons.pending_actions, Colors.orange),
              ),
              Expanded(
                child: _buildStatItem('Done', completed.toString(), Icons.check_circle, Colors.green),
              ),
              Expanded(
                child: _buildStatItem('Rate', '$completionRate%', Icons.show_chart, Colors.purple),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

