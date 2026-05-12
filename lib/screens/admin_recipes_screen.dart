import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe.dart';
import '../services/firebase_service.dart';
import '../widgets/app_widgets.dart';
import '../l10n/strings.dart';
import '../widgets/locale_aware.dart';

class AdminRecipesScreen extends StatefulWidget {
  final List<Recipe> recipes;

  const AdminRecipesScreen({super.key, required this.recipes});

  @override
  State<AdminRecipesScreen> createState() => _AdminRecipesScreenState();
}

class _AdminRecipesScreenState extends State<AdminRecipesScreen> with LocaleAwareState {
  late List<Recipe> _recipes;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _recipes = List.from(widget.recipes);
    _subscription = FirebaseService.instance.streamRecipes().listen((recipes) {
      if (mounted) setState(() {
        _recipes
          ..clear()
          ..addAll(recipes);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  List<Recipe> get _filtered => _recipes
      .where((r) => r.title.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  Future<void> _deleteRecipe(Recipe recipe) async {
    await FirebaseService.instance.deleteRecipe(recipe.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Str.deletedRecipe(recipe.title))),
    );
  }

  Future<String> _nextId() => FirebaseService.instance.nextRecipeId();

  Future<void> _showRecipeForm({Recipe? existing}) async {
    final titleEnCtrl = TextEditingController(text: existing?.titleEn ?? '');
    final titleEsCtrl = TextEditingController(text: existing?.titleEs ?? '');
    final prepCtrl = TextEditingController(text: existing?.prepTime ?? '');
    final cookCtrl = TextEditingController(text: existing?.cookTime ?? '');
    final totalCtrl = TextEditingController(text: existing?.totalTime ?? '');
    final ingEnCtrl = TextEditingController(
        text: existing?.ingredientsEn.join(', ') ?? '');
    final ingEsCtrl = TextEditingController(
        text: existing?.ingredientsEs.join(', ') ?? '');
    final stepsEnCtrl = TextEditingController(
        text: existing?.stepsEn.join('\n') ?? '');
    final stepsEsCtrl = TextEditingController(
        text: existing?.stepsEs.join('\n') ?? '');
    final ratingCtrl = TextEditingController(
        text: existing?.rating.toString() ?? '4.0');
    final imageUrlCtrl = TextEditingController(
        text: existing?.imageUrl ?? '');

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      try {
        final ref = FirebaseStorage.instance
            .ref('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putData(await picked.readAsBytes(), SettableMetadata(
          contentType: 'image/jpeg',
        ));
        final url = await ref.getDownloadURL();
        imageUrlCtrl.text = url;
        if (mounted) setState(() {});
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing != null ? Str.editRecipe : Str.newRecipe),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleEnCtrl, decoration: InputDecoration(labelText: 'Title (EN)')),
              TextField(controller: titleEsCtrl, decoration: InputDecoration(labelText: 'Título (ES)')),
              TextField(controller: prepCtrl, decoration: InputDecoration(labelText: Str.prepTime)),
              TextField(controller: cookCtrl, decoration: InputDecoration(labelText: Str.cookTime)),
              TextField(controller: totalCtrl, decoration: InputDecoration(labelText: Str.totalTime)),
              TextField(controller: ingEnCtrl, decoration: InputDecoration(labelText: 'Ingredients EN (comma)')),
              TextField(controller: ingEsCtrl, decoration: InputDecoration(labelText: 'Ingredientes ES (coma)')),
              TextField(controller: stepsEnCtrl, maxLines: 2, decoration: InputDecoration(labelText: 'Steps EN (one/line)')),
              TextField(controller: stepsEsCtrl, maxLines: 2, decoration: InputDecoration(labelText: 'Pasos ES (uno/línea)')),
              TextField(controller: ratingCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: Str.rating)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: imageUrlCtrl,
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        hintText: 'https://...',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.image_outlined),
                    tooltip: 'Pick from gallery',
                    onPressed: pickImage,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(Str.cancel)),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(Str.save)),
        ],
      ),
    );

    if (saved != true) return;
    if (titleEnCtrl.text.trim().isEmpty) return;

    final id = existing?.id ?? await _nextId();
    final recipe = Recipe(
      id: id,
      titleEn: titleEnCtrl.text.trim(),
      titleEs: titleEsCtrl.text.trim(),
      prepTime: prepCtrl.text.trim(),
      cookTime: cookCtrl.text.trim(),
      totalTime: totalCtrl.text.trim(),
      ingredientsEn: ingEnCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      ingredientsEs: ingEsCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      stepsEn: stepsEnCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      stepsEs: stepsEsCtrl.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      rating: double.tryParse(ratingCtrl.text) ?? 4.0,
      imageUrl: imageUrlCtrl.text.trim().isEmpty
          ? null
          : imageUrlCtrl.text.trim(),
    );

    if (existing != null) {
      await FirebaseService.instance.updateRecipe(recipe);
    } else {
      await FirebaseService.instance.addRecipe(recipe);
    }
  }

  void _showRecipeOptions(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(recipe.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(Str.editRecipe),
              onTap: () {
                Navigator.pop(context);
                _showRecipeForm(existing: recipe);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(Str.deleteRecipe,
                  style: const TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteRecipe(recipe);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(Str.recipePlural,
            style:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showRecipeForm(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: Str.searchRecipe,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                isDense: true,
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).colorScheme.outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? Center(
              child: Text(Str.noRecipesFound,
                  style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final recipe = _filtered[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: recipe.imageUrl != null
                        ? Image.network(
                            recipe.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : RecipeImagePlaceholder(
                            width: 56,
                            height: 56,
                            borderRadius: BorderRadius.circular(8),
                          ),
                  ),
                  title: Text(recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 13, color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 3),
                      Text(recipe.totalTime,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star,
                          size: 13, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(recipe.rating.toString(),
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showRecipeOptions(recipe),
                  ),
                );
              },
            ),
    );
  }
}
