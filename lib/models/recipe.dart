import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_locale.dart';

class Recipe {
  final String id;
  final String titleEn;
  final String titleEs;
  final String prepTime;
  final String cookTime;
  final String totalTime;
  final List<String> ingredientsEn;
  final List<String> ingredientsEs;
  final List<String> stepsEn;
  final List<String> stepsEs;
  final double rating;
  bool isLiked;
  bool isSaved;
  final String? imageUrl;
  final List<String> categories;

  Recipe({
    required this.id,
    required this.titleEn,
    required this.titleEs,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.ingredientsEn,
    required this.ingredientsEs,
    required this.stepsEn,
    required this.stepsEs,
    required this.rating,
    this.isLiked = false,
    this.isSaved = false,
    this.imageUrl,
    this.categories = const [],
  });

  String get title => AppLocale.language.value == 'es' ? titleEs : titleEn;
  List<String> get ingredients =>
      AppLocale.language.value == 'es' ? ingredientsEs : ingredientsEn;
  List<String> get steps =>
      AppLocale.language.value == 'es' ? stepsEs : stepsEn;

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleEn': titleEn,
        'titleEs': titleEs,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'totalTime': totalTime,
        'ingredientsEn': ingredientsEn,
        'ingredientsEs': ingredientsEs,
        'stepsEn': stepsEn,
        'stepsEs': stepsEs,
        'rating': rating,
        'imageUrl': imageUrl,
        'categories': categories,
      };

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: d['id'] as String? ?? doc.id,
      titleEn: d['titleEn'] as String? ?? '',
      titleEs: d['titleEs'] as String? ?? '',
      prepTime: d['prepTime'] as String? ?? '',
      cookTime: d['cookTime'] as String? ?? '',
      totalTime: d['totalTime'] as String? ?? '',
      ingredientsEn: List<String>.from(d['ingredientsEn'] as List? ?? []),
      ingredientsEs: List<String>.from(d['ingredientsEs'] as List? ?? []),
      stepsEn: List<String>.from(d['stepsEn'] as List? ?? []),
      stepsEs: List<String>.from(d['stepsEs'] as List? ?? []),
      rating: (d['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: d['imageUrl'] as String?,
      categories: List<String>.from(d['categories'] as List? ?? []),
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> d) => Recipe(
        id: d['id'] as String? ?? '',
        titleEn: d['titleEn'] as String? ?? '',
        titleEs: d['titleEs'] as String? ?? '',
        prepTime: d['prepTime'] as String? ?? '',
        cookTime: d['cookTime'] as String? ?? '',
        totalTime: d['totalTime'] as String? ?? '',
        ingredientsEn: List<String>.from(d['ingredientsEn'] as List? ?? []),
        ingredientsEs: List<String>.from(d['ingredientsEs'] as List? ?? []),
        stepsEn: List<String>.from(d['stepsEn'] as List? ?? []),
        stepsEs: List<String>.from(d['stepsEs'] as List? ?? []),
        rating: (d['rating'] as num?)?.toDouble() ?? 0.0,
        imageUrl: d['imageUrl'] as String?,
        categories: List<String>.from(d['categories'] as List? ?? []),
      );

  static double ingredientOverlap(Recipe a, Recipe b) {
    final aLower = a.ingredients.map((i) => i.toLowerCase()).toSet();
    final bLower = b.ingredients.map((i) => i.toLowerCase()).toSet();
    final intersection = aLower.intersection(bLower).length;
    final union = aLower.union(bLower).length;
    return union == 0 ? 0 : intersection / union;
  }
}
