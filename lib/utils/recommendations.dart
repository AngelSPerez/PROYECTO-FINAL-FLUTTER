import '../models/recipe.dart';

class Recommendations {
  static List<Recipe> getSimilarRecipes(
    Recipe recipe,
    List<Recipe> allRecipes, {
    int maxResults = 4,
  }) {
    final others = allRecipes.where((r) => r.id != recipe.id).toList();
    others.sort((a, b) =>
        Recipe.ingredientOverlap(b, recipe)
            .compareTo(Recipe.ingredientOverlap(a, recipe)));
    return others.take(maxResults).toList();
  }

  static List<Recipe> getRecommendedRecipes(
    List<Recipe> allRecipes,
    List<Recipe> likedRecipes, {
    int maxResults = 6,
  }) {
    if (likedRecipes.isEmpty) {
      final sorted = List<Recipe>.from(allRecipes)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      return sorted.take(maxResults).toList();
    }

    final likedIds = likedRecipes.map((r) => r.id).toSet();
    final candidates =
        allRecipes.where((r) => !likedIds.contains(r.id)).toList();

    candidates.sort((a, b) {
      double scoreA = 0, scoreB = 0;
      for (final liked in likedRecipes) {
        scoreA += Recipe.ingredientOverlap(a, liked);
        scoreB += Recipe.ingredientOverlap(b, liked);
      }
      return scoreB.compareTo(scoreA);
    });

    return candidates.take(maxResults).toList();
  }
}
