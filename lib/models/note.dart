import 'package:hive/hive.dart';

part 'note.g.dart';

/// Hive Model for Notes
/// 
/// @HiveType annotation makes this class serializable by Hive
/// typeId must be unique across all Hive types in your app
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String category;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.category,
  });

  /// Convert to Map for display
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }
}

