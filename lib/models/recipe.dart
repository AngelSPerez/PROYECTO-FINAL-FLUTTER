class Recipe {
  final String id;
  final String title;
  final String prepTime;
  final String cookTime;
  final String totalTime;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  bool isLiked;
  bool isSaved;
  // TODO: Replace with real image URL from Firebase Storage
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.ingredients,
    required this.steps,
    required this.rating,
    this.isLiked = false,
    this.isSaved = false,
    this.imageUrl,
  });
}

/// Placeholder recipes. Replace with Firebase Firestore queries.
final List<Recipe> placeholderRecipes = [
  Recipe(
    id: '1',
    title: 'Apple Pie',
    prepTime: '30min',
    cookTime: '45min',
    totalTime: '1h 15',
    ingredients: ['Apple', 'Flour', 'Sugar', 'Butter', 'Cinnamon'],
    steps: [
      'Preheat oven to 180°C.',
      'Mix flour and butter to make the dough.',
      'Peel and slice apples, toss with sugar and cinnamon.',
      'Line pie dish with dough, add filling, cover with top crust.',
      'Bake for 45 minutes until golden.',
    ],
    rating: 4.7,
  ),
  Recipe(
    id: '2',
    title: 'Chicken',
    prepTime: '10min',
    cookTime: '25min',
    totalTime: '35min',
    ingredients: ['Chicken leg', 'Garlic', 'Olive oil', 'Salt', 'Black pepper', 'Paprika'],
    steps: [
      'Season chicken with salt, pepper and paprika.',
      'Heat olive oil in a pan over medium-high heat.',
      'Cook chicken for 12 minutes per side until golden.',
      'Rest for 5 minutes before serving.',
    ],
    rating: 4.5,
    isLiked: true,
  ),
  Recipe(
    id: '3',
    title: 'Cheesecake',
    prepTime: '30min',
    cookTime: '1h',
    totalTime: '10h 45',
    ingredients: ['Cream cheese', 'Sugar', 'Eggs', 'Vanilla extract', 'Graham crackers', 'Butter'],
    steps: [
      'Crush crackers and mix with melted butter. Press into pan.',
      'Beat cream cheese with sugar until smooth.',
      'Add eggs and vanilla, mix well.',
      'Pour over crust and bake at 160°C for 1 hour.',
      'Refrigerate overnight before serving.',
    ],
    rating: 4.8,
  ),
  Recipe(
    id: '4',
    title: 'Cookies',
    prepTime: '15min',
    cookTime: '45min',
    totalTime: '1h',
    ingredients: ['Flour', 'Sugar', 'Brown sugar', 'Butter', 'Chocolate chips', 'Eggs', 'Vanilla'],
    steps: [
      'Preheat oven to 175°C.',
      'Cream butter and sugars together.',
      'Beat in eggs and vanilla.',
      'Mix in flour, then fold in chocolate chips.',
      'Drop spoonfuls on baking sheet and bake 10–12 minutes.',
    ],
    rating: 4.6,
    isLiked: true,
  ),
  Recipe(
    id: '5',
    title: 'Wings',
    prepTime: '15min',
    cookTime: '50min',
    totalTime: '1h 5',
    ingredients: ['Chicken wings', 'Hot sauce', 'Butter', 'Garlic powder', 'Salt'],
    steps: [
      'Pat wings dry, season with salt and garlic powder.',
      'Bake at 200°C for 45 minutes, flipping halfway.',
      'Melt butter and mix with hot sauce.',
      'Toss baked wings in sauce and serve immediately.',
    ],
    rating: 4.4,
  ),
  Recipe(
    id: '6',
    title: 'Pasta',
    prepTime: '10min',
    cookTime: '20min',
    totalTime: '30min',
    ingredients: ['Spaghetti', 'Tomato sauce', 'Garlic', 'Olive oil', 'Parmesan', 'Basil'],
    steps: [
      'Boil pasta in salted water per package directions.',
      'Sauté garlic in olive oil, add tomato sauce, simmer 10 min.',
      'Drain pasta and toss with sauce.',
      'Top with Parmesan and fresh basil.',
    ],
    rating: 4.3,
    isSaved: true,
  ),
  Recipe(
    id: '7',
    title: 'Tacos',
    prepTime: '20min',
    cookTime: '15min',
    totalTime: '35min',
    ingredients: ['Corn tortillas', 'Ground beef', 'Onion', 'Cilantro', 'Lime', 'Salsa'],
    steps: [
      'Cook ground beef with diced onion until browned.',
      'Season with cumin, chili powder, salt.',
      'Warm tortillas on a dry pan.',
      'Assemble with beef, cilantro, salsa and a squeeze of lime.',
    ],
    rating: 4.7,
  ),
  Recipe(
    id: '8',
    title: 'Pancakes',
    prepTime: '10min',
    cookTime: '20min',
    totalTime: '30min',
    ingredients: ['Flour', 'Milk', 'Eggs', 'Butter', 'Baking powder', 'Salt', 'Maple syrup'],
    steps: [
      'Whisk dry ingredients together.',
      'Mix wet ingredients separately, then combine both.',
      'Cook on buttered griddle, 2–3 min per side.',
      'Serve with maple syrup and extra butter.',
    ],
    rating: 4.5,
  ),
];