import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/product.dart';
import '../objectbox.g.dart'; // Generated code (includes ObjectBox imports)

/// ObjectBox Service
/// 
/// Manages the ObjectBox store and provides high-performance
/// CRUD operations for products
class ObjectBoxService {
  /// The ObjectBox store instance
  late final Store _store;

  /// Box for Product entities
  late final Box<Product> _productBox;

  /// Private constructor for singleton pattern
  ObjectBoxService._create(this._store) {
    _productBox = Box<Product>(_store);
  }

  /// Create and initialize ObjectBox store
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'objectbox'));
    return ObjectBoxService._create(store);
  }

  /// Get a stream of all products (reactive updates)
  Stream<List<Product>> watchAllProducts() {
    final builder = _productBox.query();
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  /// Get all products (one-time query)
  List<Product> getAllProducts() {
    return _productBox.getAll();
  }

  /// Get products by category
  List<Product> getProductsByCategory(String category) {
    final query = _productBox
        .query(Product_.category.equals(category))
        .build();
    return query.find();
  }

  /// Get low stock products (quantity < 10)
  List<Product> getLowStockProducts() {
    final query = _productBox
        .query(Product_.quantity.lessThan(10))
        .order(Product_.quantity)
        .build();
    return query.find();
  }

  /// Get products by in-stock status
  List<Product> getProductsByStockStatus(bool inStock) {
    final query = _productBox
        .query(Product_.inStock.equals(inStock))
        .build();
    return query.find();
  }

  /// Search products by name
  List<Product> searchProducts(String searchTerm) {
    final query = _productBox
        .query(Product_.name.contains(searchTerm, caseSensitive: false))
        .build();
    return query.find();
  }

  /// Get a single product by ID
  Product? getProductById(int id) {
    return _productBox.get(id);
  }

  /// Add a new product
  int addProduct(Product product) {
    product.createdAt = DateTime.now();
    product.updatedAt = DateTime.now();
    return _productBox.put(product);
  }

  /// Add multiple products at once (batch operation)
  List<int> addProducts(List<Product> products) {
    for (var product in products) {
      product.createdAt = DateTime.now();
      product.updatedAt = DateTime.now();
    }
    return _productBox.putMany(products);
  }

  /// Update a product
  int updateProduct(Product product) {
    product.updatedAt = DateTime.now();
    return _productBox.put(product);
  }

  /// Delete a product
  bool deleteProduct(int id) {
    return _productBox.remove(id);
  }

  /// Delete multiple products
  int deleteProducts(List<int> ids) {
    return _productBox.removeMany(ids);
  }

  /// Clear all products
  int clearAllProducts() {
    return _productBox.removeAll();
  }

  /// Get total count of products
  int getProductCount() {
    return _productBox.count();
  }

  /// Get total inventory value
  double getTotalInventoryValue() {
    final products = getAllProducts();
    return products.fold(0.0, (sum, product) => sum + product.totalValue);
  }

  /// Get products count by category
  Map<String, int> getProductCountByCategory() {
    final products = getAllProducts();
    final Map<String, int> categoryCounts = {};
    
    for (var product in products) {
      categoryCounts[product.category] = 
          (categoryCounts[product.category] ?? 0) + 1;
    }
    
    return categoryCounts;
  }

  /// Get total value by category
  Map<String, double> getTotalValueByCategory() {
    final products = getAllProducts();
    final Map<String, double> categoryValues = {};
    
    for (var product in products) {
      categoryValues[product.category] = 
          (categoryValues[product.category] ?? 0.0) + product.totalValue;
    }
    
    return categoryValues;
  }

  /// Update stock quantity
  bool updateStock(int productId, int newQuantity) {
    final product = getProductById(productId);
    if (product == null) return false;
    
    product.quantity = newQuantity;
    product.inStock = newQuantity > 0;
    product.updatedAt = DateTime.now();
    _productBox.put(product);
    
    return true;
  }

  /// Increase stock quantity
  bool increaseStock(int productId, int amount) {
    final product = getProductById(productId);
    if (product == null) return false;
    
    product.quantity += amount;
    product.inStock = true;
    product.updatedAt = DateTime.now();
    _productBox.put(product);
    
    return true;
  }

  /// Decrease stock quantity
  bool decreaseStock(int productId, int amount) {
    final product = getProductById(productId);
    if (product == null || product.quantity < amount) return false;
    
    product.quantity -= amount;
    product.inStock = product.quantity > 0;
    product.updatedAt = DateTime.now();
    _productBox.put(product);
    
    return true;
  }

  /// Close the store
  void close() {
    _store.close();
  }
}

