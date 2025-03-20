import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController {
  static const String favoritesKey = 'favorite_pokemons';

  // Obtiene la lista de IDs favoritos
  static Future<List<int>> getFavoritePokemons() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteStrings = prefs.getStringList(favoritesKey);

    if (favoriteStrings != null) {
      return favoriteStrings.map((id) => int.parse(id)).toList();
    }
    return [];
  }

  // Guarda la lista de IDs favoritos
  static Future<void> saveFavoritePokemons(List<int> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteStrings = favoriteIds.map((id) => id.toString()).toList();
    await prefs.setStringList(favoritesKey, favoriteStrings);
  }

  // Agrega o quita un Pokémon de favoritos
  static Future<void> toggleFavorite(int pokemonId) async {
    List<int> favorites = await getFavoritePokemons();

    if (favorites.contains(pokemonId)) {
      favorites.remove(pokemonId);
    } else {
      favorites.add(pokemonId);
    }

    await saveFavoritePokemons(favorites);
  }

  // Verifica si un Pokémon es favorito
  static Future<bool> isFavorite(int pokemonId) async {
    List<int> favorites = await getFavoritePokemons();
    return favorites.contains(pokemonId);
  }
}
