import 'package:flutter/material.dart';
import 'shared_prefs_screen.dart';
import 'hive_screen.dart';
import 'sqflite_screen.dart';
import 'drift_screen.dart';
import 'objectbox_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '100 Days of Flutter',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Local Databases\nMastery',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Explore different database solutions for Flutter',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DatabaseCard(
                      title: 'SharedPreferences',
                      subtitle: 'Simple Key-Value Store',
                      description: 'Store lightweight preferences like theme, login state, or language',
                      icon: Icons.settings_applications,
                      color: Colors.blue,
                      useCases: ['User preferences', 'App settings', 'Simple flags'],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SharedPrefsScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DatabaseCard(
                      title: 'Hive',
                      subtitle: 'Pure Dart NoSQL Database',
                      description: 'Fast, offline-friendly local storage with no native dependencies',
                      icon: Icons.inventory_2,
                      color: Colors.amber,
                      useCases: ['Caching API data', 'Chat messages', 'App states'],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HiveScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DatabaseCard(
                      title: 'ObjectBox',
                      subtitle: 'High-Performance Object Database',
                      description: '10x faster than SQLite, perfect for large datasets',
                      icon: Icons.rocket_launch,
                      color: Colors.deepOrange,
                      useCases: ['IoT dashboards', 'Analytics', 'Real-time tracking'],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ObjectBoxScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DatabaseCard(
                      title: 'SQFlite',
                      subtitle: 'SQLite for Flutter',
                      description: 'Mature, stable relational database with full SQL control',
                      icon: Icons.table_chart,
                      color: Colors.green,
                      useCases: ['Expense trackers', 'Inventory systems', 'Contact managers'],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SQFliteScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DatabaseCard(
                      title: 'Drift (Moor)',
                      subtitle: 'Reactive ORM for SQLite',
                      description: 'SQL structure + Dart convenience with reactive streams',
                      icon: Icons.sync_alt,
                      color: Colors.purple,
                      useCases: ['Todo apps', 'Notes apps', 'Reactive UI updates'],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DriftScreen()),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatabaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> useCases;
  final VoidCallback onTap;

  const DatabaseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.useCases,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: useCases.map((useCase) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      useCase,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

