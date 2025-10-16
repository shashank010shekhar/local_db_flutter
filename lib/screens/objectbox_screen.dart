import 'package:flutter/material.dart';
import '../models/product.dart';
import '../main.dart';

/// ObjectBox Demo Screen
/// 
/// Demonstrates:
/// - High-performance object database
/// - Complex queries and filtering
/// - Real-time reactive updates
/// - Batch operations
/// - Perfect for large datasets
class ObjectBoxScreen extends StatefulWidget {
  const ObjectBoxScreen({super.key});

  @override
  State<ObjectBoxScreen> createState() => _ObjectBoxScreenState();
}

class _ObjectBoxScreenState extends State<ObjectBoxScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _skuController = TextEditingController();
  String _selectedCategory = 'Electronics';
  
  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Food',
    'Books',
    'Home',
    'Sports',
    'Toys',
  ];

  String _filterCategory = 'All';
  bool _showLowStockOnly = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  /// Add a new product
  void _addProduct() {
    if (_nameController.text.isEmpty || 
        _priceController.text.isEmpty || 
        _quantityController.text.isEmpty ||
        _skuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    final quantity = int.tryParse(_quantityController.text);

    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    if (quantity == null || quantity < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    final product = Product(
      name: _nameController.text,
      description: _descriptionController.text.isEmpty 
          ? null 
          : _descriptionController.text,
      price: price,
      quantity: quantity,
      category: _selectedCategory,
      sku: _skuController.text,
      inStock: quantity > 0,
      createdAt: DateTime.now(),
    );

    objectBoxService.addProduct(product);
    setState(() {});

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    _skuController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully!')),
    );
  }

  /// Delete a product
  void _deleteProduct(int id) {
    objectBoxService.deleteProduct(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted!')),
    );
  }

  /// Update stock
  void _updateStock(Product product, int newQuantity) {
    objectBoxService.updateStock(product.id, newQuantity);
    setState(() {});
  }

  /// Show edit dialog
  void _showEditDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final descController = TextEditingController(text: product.description ?? '');
    final priceController = TextEditingController(text: product.price.toString());
    final qtyController = TextEditingController(text: product.quantity.toString());
    final skuController = TextEditingController(text: product.sku);
    String category = product.category;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: skuController,
                  decoration: const InputDecoration(
                    labelText: 'SKU',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: qtyController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => category = value);
                    }
                  },
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);
                final qty = int.tryParse(qtyController.text);
                
                if (nameController.text.isNotEmpty && 
                    price != null && 
                    qty != null &&
                    skuController.text.isNotEmpty) {
                  product.name = nameController.text;
                  product.description = descController.text.isEmpty 
                      ? null 
                      : descController.text;
                  product.price = price;
                  product.quantity = qty;
                  product.category = category;
                  product.sku = skuController.text;
                  product.inStock = qty > 0;
                  
                  objectBoxService.updateProduct(product);
                  setState(() {});
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

  /// Add sample products
  void _addSampleProducts() {
    final samples = [
      Product(
        name: 'iPhone 15 Pro',
        description: 'Latest Apple smartphone with A17 Pro chip',
        price: 999.99,
        quantity: 25,
        category: 'Electronics',
        sku: 'IPH-15-PRO-001',
        inStock: true,
        createdAt: DateTime.now(),
      ),
      Product(
        name: 'Nike Air Max',
        description: 'Comfortable running shoes',
        price: 129.99,
        quantity: 8,
        category: 'Sports',
        sku: 'NIK-AM-001',
        inStock: true,
        createdAt: DateTime.now(),
      ),
      Product(
        name: 'Harry Potter Set',
        description: 'Complete book series',
        price: 79.99,
        quantity: 3,
        category: 'Books',
        sku: 'HP-SET-001',
        inStock: true,
        createdAt: DateTime.now(),
      ),
    ];

    objectBoxService.addProducts(samples);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample products added!')),
    );
  }

  /// Get filtered products
  List<Product> _getFilteredProducts() {
    var products = objectBoxService.getAllProducts();

    if (_showLowStockOnly) {
      products = objectBoxService.getLowStockProducts();
    } else if (_filterCategory != 'All') {
      products = objectBoxService.getProductsByCategory(_filterCategory);
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBox - Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: _addSampleProducts,
            tooltip: 'Add sample products',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              objectBoxService.clearAllProducts();
              setState(() {});
            },
            tooltip: 'Clear all products',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoCard(),
          _buildInputSection(),
          _buildFilterSection(),
          _buildStatsCard(),
          const Divider(height: 1),
          Expanded(child: _buildProductsList()),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.deepOrange.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.deepOrange.shade700, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ObjectBox - High Performance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '10x faster than SQLite, perfect for large datasets',
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _skuController,
                  decoration: const InputDecoration(
                    labelText: 'SKU *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price *',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Qty *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 20),
          const SizedBox(width: 8),
          const Text('Filter:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filterCategory == 'All' && !_showLowStockOnly,
                    onSelected: (selected) {
                      setState(() {
                        _filterCategory = 'All';
                        _showLowStockOnly = false;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Low Stock'),
                    selected: _showLowStockOnly,
                    selectedColor: Colors.red.shade100,
                    onSelected: (selected) {
                      setState(() => _showLowStockOnly = selected);
                    },
                  ),
                  const SizedBox(width: 8),
                  ..._categories.map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: _filterCategory == cat && !_showLowStockOnly,
                          onSelected: (selected) {
                            setState(() {
                              _filterCategory = cat;
                              _showLowStockOnly = false;
                            });
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final totalValue = objectBoxService.getTotalInventoryValue();
    final productCount = objectBoxService.getProductCount();
    final lowStockCount = objectBoxService.getLowStockProducts().length;

    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Total Products',
              productCount.toString(),
              Icons.inventory_2,
              Colors.blue,
            ),
            _buildStatItem(
              'Total Value',
              '\$${totalValue.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
            ),
            _buildStatItem(
              'Low Stock',
              lowStockCount.toString(),
              Icons.warning,
              lowStockCount > 0 ? Colors.red : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
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
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProductsList() {
    final products = _getFilteredProducts();

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first product above',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final categoryColor = _getCategoryColor(product.category);
    final needsRestock = product.needsRestocking;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: needsRestock ? Colors.red.shade50 : null,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withOpacity(0.2),
          child: Icon(_getCategoryIcon(product.category), color: categoryColor),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${product.sku}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    product.category,
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (needsRestock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning, size: 12, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.description != null) ...[
                  Text(
                    'Description:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(product.description!),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem('Stock', '${product.quantity} units'),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Total Value',
                        '\$${product.totalValue.toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Status',
                        product.inStock ? 'In Stock' : 'Out of Stock',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Added',
                        _formatDate(product.createdAt),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showEditDialog(product),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _deleteProduct(product.id),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _updateStock(product, product.quantity - 1),
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: 'Decrease stock',
                    ),
                    Text('${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => _updateStock(product, product.quantity + 1),
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Increase stock',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Electronics':
        return Colors.blue;
      case 'Clothing':
        return Colors.purple;
      case 'Food':
        return Colors.orange;
      case 'Books':
        return Colors.brown;
      case 'Home':
        return Colors.green;
      case 'Sports':
        return Colors.red;
      case 'Toys':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Icons.devices;
      case 'Clothing':
        return Icons.checkroom;
      case 'Food':
        return Icons.restaurant;
      case 'Books':
        return Icons.book;
      case 'Home':
        return Icons.home;
      case 'Sports':
        return Icons.sports_basketball;
      case 'Toys':
        return Icons.toys;
      default:
        return Icons.category;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

