import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _recipes => _db.collection('recipes');
  CollectionReference get _comments => _db.collection('comments');
  CollectionReference get _ratings => _db.collection('ratings');
  CollectionReference get _saved => _db.collection('saved');
  CollectionReference get _liked => _db.collection('liked');
  CollectionReference get _users => _db.collection('users');

  Future<void> seedRecipes() async {
    final snap = await _recipes.get();
    if (snap.docs.isNotEmpty) return;

    final batch = _db.batch();
    for (final data in _seedData) {
      final ref = _recipes.doc(data['id'] as String);
      batch.set(ref, data);
    }
    await batch.commit();
  }

  Stream<List<Recipe>> streamRecipes() =>
      _recipes.snapshots().map((s) => s.docs.map((d) => Recipe.fromFirestore(d)).toList());

  Future<List<Recipe>> getRecipes() async {
    final snap = await _recipes.get();
    return snap.docs.map((d) => Recipe.fromFirestore(d)).toList();
  }

  Future<void> addRecipe(Recipe recipe) =>
      _recipes.doc(recipe.id).set(recipe.toMap());

  Future<void> updateRecipe(Recipe recipe) =>
      _recipes.doc(recipe.id).update(recipe.toMap());

  Future<void> deleteRecipe(String id) => _recipes.doc(id).delete();

  Future<String> nextRecipeId() async {
    final snap = await _recipes.orderBy('id', descending: true).limit(1).get();
    if (snap.docs.isEmpty) return '1';
    final last = int.tryParse(snap.docs.first.id) ?? 0;
    return '${last + 1}';
  }

  Stream<List<Map<String, dynamic>>> streamComments() =>
      _comments.orderBy('time', descending: true).snapshots().map(_mapDocs);

  Future<void> addComment(Map<String, dynamic> data) =>
      _comments.add(data);

  Future<void> updateComment(String docId, Map<String, dynamic> data) =>
      _comments.doc(docId).update(data);

  Future<void> deleteComment(String docId) =>
      _comments.doc(docId).delete();

  Stream<List<Map<String, dynamic>>> streamRatings() =>
      _ratings.orderBy('stars', descending: true).snapshots().map(_mapDocs);

  Future<String> addRating(Map<String, dynamic> data) async {
    final ref = await _ratings.add(data);
    return ref.id;
  }

  Future<void> updateRating(String docId, Map<String, dynamic> data) =>
      _ratings.doc(docId).update(data);

  Future<void> deleteRating(String docId) =>
      _ratings.doc(docId).delete();

  Stream<List<Map<String, dynamic>>> streamSaved() =>
      _saved.orderBy('savedAt', descending: true).snapshots().map(_mapDocs);

  Future<void> addSaved(Map<String, dynamic> data) =>
      _saved.add(data);

  Future<void> deleteSaved(String docId) =>
      _saved.doc(docId).delete();

  Stream<List<Map<String, dynamic>>> streamLiked() =>
      _liked.snapshots().map(_mapDocs);

  Future<Map<String, dynamic>?> getLikedByUserAndRecipe(String user, int recipeIdx) async {
    final snap = await _liked.where('user', isEqualTo: user).where('recipeIdx', isEqualTo: recipeIdx).get();
    if (snap.docs.isEmpty) return null;
    final d = snap.docs.first;
    return {'id': d.id, ...d.data() as Map<String, dynamic>};
  }

  Future<Map<String, dynamic>?> getSavedByUserAndRecipe(String user, int recipeIdx) async {
    final snap = await _saved.where('user', isEqualTo: user).where('recipeIdx', isEqualTo: recipeIdx).get();
    if (snap.docs.isEmpty) return null;
    final d = snap.docs.first;
    return {'id': d.id, ...d.data() as Map<String, dynamic>};
  }

  Future<void> addLiked(Map<String, dynamic> data) =>
      _liked.add(data);

  Future<void> deleteLiked(String docId) =>
      _liked.doc(docId).delete();

  Stream<List<Map<String, dynamic>>> streamUsers() =>
      _users.snapshots().map(_mapDocs);

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _users.doc(uid).update(data);

  Future<void> deleteUser(String uid) async {
    await _users.doc(uid).delete();
  }

  List<Map<String, dynamic>> _mapDocs(QuerySnapshot snap) =>
      snap.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList();

  static const _seedData = [
    {
      'id': '1',
      'titleEn': 'Apple Pie',
      'titleEs': 'Pay de manzana',
      'prepTime': '30min',
      'cookTime': '45min',
      'totalTime': '1h 15',
      'ingredientsEn': ['Apple', 'Flour', 'Sugar', 'Butter', 'Cinnamon'],
      'ingredientsEs': ['Manzana', 'Harina', 'Azúcar', 'Mantequilla', 'Canela'],
      'stepsEn': [
        'Preheat oven to 180°C.',
        'Mix flour and butter to make the dough.',
        'Peel and slice apples, toss with sugar and cinnamon.',
        'Line pie dish with dough, add filling, cover with top crust.',
        'Bake for 45 minutes until golden.',
      ],
      'stepsEs': [
        'Precalienta el horno a 180°C.',
        'Mezcla la harina con la mantequilla para hacer la masa.',
        'Pela y rebana las manzanas, mezcla con azúcar y canela.',
        'Forra el molde con masa, agrega el relleno, cubre con la tapa.',
        'Hornea 45 minutos hasta que esté dorado.',
      ],
      'rating': 4.7,
      'imageUrl': null,
      'categories': ['Dessert'],
    },
    {
      'id': '2',
      'titleEn': 'Chicken',
      'titleEs': 'Pollo',
      'prepTime': '10min',
      'cookTime': '25min',
      'totalTime': '35min',
      'ingredientsEn': ['Chicken leg', 'Garlic', 'Olive oil', 'Salt', 'Black pepper', 'Paprika'],
      'ingredientsEs': ['Pierna de pollo', 'Ajo', 'Aceite de oliva', 'Sal', 'Pimienta negra', 'Paprika'],
      'stepsEn': [
        'Season chicken with salt, pepper and paprika.',
        'Heat olive oil in a pan over medium-high heat.',
        'Cook chicken for 12 minutes per side until golden.',
        'Rest for 5 minutes before serving.',
      ],
      'stepsEs': [
        'Sazona el pollo con sal, pimienta y paprika.',
        'Calienta aceite de oliva en una sartén a fuego medio-alto.',
        'Cocina el pollo 12 minutos por lado hasta que dore.',
        'Reposa 5 minutos antes de servir.',
      ],
      'rating': 4.5,
      'imageUrl': null,
      'categories': ['Main Dish'],
    },
    {
      'id': '3',
      'titleEn': 'Cheesecake',
      'titleEs': 'Pastel de queso',
      'prepTime': '30min',
      'cookTime': '1h',
      'totalTime': '10h 45',
      'ingredientsEn': ['Cream cheese', 'Sugar', 'Eggs', 'Vanilla extract', 'Graham crackers', 'Butter'],
      'ingredientsEs': ['Queso crema', 'Azúcar', 'Huevos', 'Extracto de vainilla', 'Galletas Graham', 'Mantequilla'],
      'stepsEn': [
        'Crush crackers and mix with melted butter. Press into pan.',
        'Beat cream cheese with sugar until smooth.',
        'Add eggs and vanilla, mix well.',
        'Pour over crust and bake at 160°C for 1 hour.',
        'Refrigerate overnight before serving.',
      ],
      'stepsEs': [
        'Tritura las galletas y mezcla con mantequilla derretida. Presiona en el molde.',
        'Bate el queso crema con el azúcar hasta que esté suave.',
        'Agrega los huevos y la vainilla, mezcla bien.',
        'Vierte sobre la base y hornea a 160°C por 1 hora.',
        'Refrigera toda la noche antes de servir.',
      ],
      'rating': 4.8,
      'imageUrl': null,
      'categories': ['Dessert'],
    },
    {
      'id': '4',
      'titleEn': 'Cookies',
      'titleEs': 'Galletas',
      'prepTime': '15min',
      'cookTime': '45min',
      'totalTime': '1h',
      'ingredientsEn': ['Flour', 'Sugar', 'Brown sugar', 'Butter', 'Chocolate chips', 'Eggs', 'Vanilla'],
      'ingredientsEs': ['Harina', 'Azúcar', 'Azúcar morena', 'Mantequilla', 'Chispas de chocolate', 'Huevos', 'Vainilla'],
      'stepsEn': [
        'Preheat oven to 175°C.',
        'Cream butter and sugars together.',
        'Beat in eggs and vanilla.',
        'Mix in flour, then fold in chocolate chips.',
        'Drop spoonfuls on baking sheet and bake 10–12 minutes.',
      ],
      'stepsEs': [
        'Precalienta el horno a 175°C.',
        'Bate la mantequilla con los azúcares.',
        'Incorpora los huevos y la vainilla.',
        'Agrega la harina, luego incorpora las chispas de chocolate.',
        'Coloca cucharadas en una bandeja y hornea 10–12 minutos.',
      ],
      'rating': 4.6,
      'imageUrl': null,
      'categories': ['Dessert'],
    },
    {
      'id': '5',
      'titleEn': 'Wings',
      'titleEs': 'Alitas',
      'prepTime': '15min',
      'cookTime': '50min',
      'totalTime': '1h 5',
      'ingredientsEn': ['Chicken wings', 'Hot sauce', 'Butter', 'Garlic powder', 'Salt'],
      'ingredientsEs': ['Alitas de pollo', 'Salsa picante', 'Mantequilla', 'Ajo en polvo', 'Sal'],
      'stepsEn': [
        'Pat wings dry, season with salt and garlic powder.',
        'Bake at 200°C for 45 minutes, flipping halfway.',
        'Melt butter and mix with hot sauce.',
        'Toss baked wings in sauce and serve immediately.',
      ],
      'stepsEs': [
        'Seca las alitas, sazona con sal y ajo en polvo.',
        'Hornea a 200°C por 45 minutos, volteando a la mitad.',
        'Derrite la mantequilla y mezcla con salsa picante.',
        'Baña las alitas horneadas en la salsa y sirve de inmediato.',
      ],
      'rating': 4.4,
      'imageUrl': null,
      'categories': ['Appetizer'],
    },
    {
      'id': '6',
      'titleEn': 'Pasta',
      'titleEs': 'Pasta',
      'prepTime': '10min',
      'cookTime': '20min',
      'totalTime': '30min',
      'ingredientsEn': ['Spaghetti', 'Tomato sauce', 'Garlic', 'Olive oil', 'Parmesan', 'Basil'],
      'ingredientsEs': ['Espagueti', 'Salsa de tomate', 'Ajo', 'Aceite de oliva', 'Parmesano', 'Albahaca'],
      'stepsEn': [
        'Boil pasta in salted water per package directions.',
        'Sauté garlic in olive oil, add tomato sauce, simmer 10 min.',
        'Drain pasta and toss with sauce.',
        'Top with Parmesan and fresh basil.',
      ],
      'stepsEs': [
        'Hierve la pasta en agua con sal según las instrucciones.',
        'Sofríe el ajo en aceite de oliva, agrega salsa de tomate, cocina 10 min.',
        'Escurre la pasta y mezcla con la salsa.',
        'Cubre con parmesano y albahaca fresca.',
      ],
      'rating': 4.3,
      'imageUrl': null,
      'categories': ['Main Dish'],
    },
    {
      'id': '7',
      'titleEn': 'Tacos',
      'titleEs': 'Tacos',
      'prepTime': '20min',
      'cookTime': '15min',
      'totalTime': '35min',
      'ingredientsEn': ['Corn tortillas', 'Ground beef', 'Onion', 'Cilantro', 'Lime', 'Salsa'],
      'ingredientsEs': ['Tortillas de maíz', 'Carne molida', 'Cebolla', 'Cilantro', 'Limón', 'Salsa'],
      'stepsEn': [
        'Cook ground beef with diced onion until browned.',
        'Season with cumin, chili powder, salt.',
        'Warm tortillas on a dry pan.',
        'Assemble with beef, cilantro, salsa and a squeeze of lime.',
      ],
      'stepsEs': [
        'Cocina la carne molida con cebolla picada hasta que dore.',
        'Sazona con comino, chile en polvo y sal.',
        'Calienta las tortillas en un comal.',
        'Arma con la carne, cilantro, salsa y un poco de limón.',
      ],
      'rating': 4.7,
      'imageUrl': null,
      'categories': ['Main Dish'],
    },
    {
      'id': '8',
      'titleEn': 'Pancakes',
      'titleEs': 'Panqueques',
      'prepTime': '10min',
      'cookTime': '20min',
      'totalTime': '30min',
      'ingredientsEn': ['Flour', 'Milk', 'Eggs', 'Butter', 'Baking powder', 'Salt', 'Maple syrup'],
      'ingredientsEs': ['Harina', 'Leche', 'Huevos', 'Mantequilla', 'Polvo para hornear', 'Sal', 'Jarabe de arce'],
      'stepsEn': [
        'Whisk dry ingredients together.',
        'Mix wet ingredients separately, then combine both.',
        'Cook on buttered griddle, 2–3 min per side.',
        'Serve with maple syrup and extra butter.',
      ],
      'stepsEs': [
        'Mezcla los ingredientes secos.',
        'Mezcla los ingredientes húmedos por separado, luego combínalos.',
        'Cocina en un comal enmantequillado, 2–3 min por lado.',
        'Sirve con jarabe de arce y mantequilla extra.',
      ],
      'rating': 4.5,
      'imageUrl': null,
      'categories': ['Breakfast'],
    },
  ];
}
