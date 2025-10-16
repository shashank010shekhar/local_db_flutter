import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Demo Screen
/// 
/// Demonstrates:
/// - Storing simple key-value pairs
/// - Different data types (String, int, bool, double)
/// - Use case: User preferences and app settings
class SharedPrefsScreen extends StatefulWidget {
  const SharedPrefsScreen({super.key});

  @override
  State<SharedPrefsScreen> createState() => _SharedPrefsScreenState();
}

class _SharedPrefsScreenState extends State<SharedPrefsScreen> {
  String _username = '';
  int _loginCount = 0;
  bool _isDarkMode = false;
  double _fontSize = 14.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Load all preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _username = prefs.getString('username') ?? 'Guest';
      _loginCount = prefs.getInt('loginCount') ?? 0;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 14.0;
      _isLoading = false;
    });
  }

  /// Save username
  Future<void> _saveUsername(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', value);
    setState(() => _username = value);
  }

  /// Increment login count
  Future<void> _incrementLoginCount() async {
    final prefs = await SharedPreferences.getInstance();
    final newCount = _loginCount + 1;
    await prefs.setInt('loginCount', newCount);
    setState(() => _loginCount = newCount);
  }

  /// Toggle dark mode
  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() => _isDarkMode = value);
  }

  /// Update font size
  Future<void> _updateFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
    setState(() => _fontSize = value);
  }

  /// Clear all preferences
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadPreferences();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All preferences cleared!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SharedPreferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearAll,
            tooltip: 'Clear all preferences',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildUsernameCard(),
                  const SizedBox(height: 16),
                  _buildLoginCountCard(),
                  const SizedBox(height: 16),
                  _buildDarkModeCard(),
                  const SizedBox(height: 16),
                  _buildFontSizeCard(),
                  const SizedBox(height: 24),
                  _buildExplanationCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SharedPreferences',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Perfect for storing simple key-value pairs like user preferences and settings.',
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

  Widget _buildUsernameCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Username (String)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Current: $_username', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter new username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              onSubmitted: _saveUsername,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.login, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Login Count (Integer)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'You\'ve logged in $_loginCount times',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _incrementLoginCount,
              icon: const Icon(Icons.add),
              label: const Text('Simulate Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Dark Mode (Boolean)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(_isDarkMode ? 'Dark Mode ON' : 'Dark Mode OFF'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.format_size, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Font Size (Double)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Sample text at ${_fontSize.toStringAsFixed(1)}px',
              style: TextStyle(fontSize: _fontSize),
            ),
            Slider(
              value: _fontSize,
              min: 10,
              max: 30,
              divisions: 20,
              label: _fontSize.toStringAsFixed(1),
              onChanged: _updateFontSize,
              activeColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Card(
      color: Colors.amber.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Key Concepts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBulletPoint('✓ Stores data in native platform preferences'),
            _buildBulletPoint('✓ Supports String, int, bool, double, List<String>'),
            _buildBulletPoint('✓ Data persists across app restarts'),
            _buildBulletPoint('✓ Best for small amounts of data'),
            _buildBulletPoint('✓ Not suitable for complex objects or large datasets'),
            _buildBulletPoint('✓ Fast and synchronous access after initial load'),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

