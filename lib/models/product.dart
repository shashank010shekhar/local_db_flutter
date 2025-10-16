import 'package:objectbox/objectbox.dart';

/// ObjectBox Model for Products
/// 
/// Demonstrates ObjectBox's object-oriented approach to data storage
/// Perfect for inventory management, e-commerce, or product catalogs
@Entity()
class Product {
  /// ObjectBox requires an int ID with @Id() annotation
  @Id()
  int id;

  /// Product name
  String name;

  /// Product description
  String? description;

  /// Price in dollars
  double price;

  /// Quantity in stock
  int quantity;

  /// Product category
  String category;

  /// SKU (Stock Keeping Unit)
  String sku;

  /// Whether the product is in stock
  bool inStock;

  /// Created at timestamp (stored as milliseconds since epoch)
  @Property(type: PropertyType.date)
  DateTime createdAt;

  /// Last updated timestamp
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  Product({
    this.id = 0, // ObjectBox auto-assigns IDs, 0 means not persisted yet
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.sku,
    required this.inStock,
    required this.createdAt,
    this.updatedAt,
  });

  /// Calculate total value of this product in inventory
  double get totalValue => price * quantity;

  /// Check if product needs restocking (quantity < 10)
  bool get needsRestocking => quantity < 10;

  /// Convert to Map for display
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'sku': sku,
      'inStock': inStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

