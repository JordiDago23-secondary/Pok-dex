class PokeModel {
  final int id;
  final String name;
  final String url;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;
  final List<String> abilities; // ✅ Nueva propiedad

  PokeModel({
    required this.id,
    required this.name,
    required this.url,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities, // ✅ La incluimos aquí
  });

  /// Carga básica desde el listado de pokemons
  factory PokeModel.fromJson(Map<String, dynamic> json) {
    final uri = Uri.parse(json['url']);
    final id = int.parse(uri.pathSegments[uri.pathSegments.length - 2]);

    return PokeModel(
      id: id,
      name: _capitalize(json['name']),
      url: json['url'],
      types: [],
      height: 0,
      weight: 0,
      stats: {},
      abilities: [], // ✅ Lista vacía en el modelo básico
    );
  }

  /// Carga los detalles del Pokémon
  factory PokeModel.fromDetailJson(Map<String, dynamic> json, PokeModel basicModel) {
    List<String> types = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    Map<String, int> stats = {};
    (json['stats'] as List).forEach((stat) {
      stats[stat['stat']['name']] = stat['base_stat'];
    });

    /// ✅ Obtener las habilidades del Pokémon
    List<String> abilities = (json['abilities'] as List)
        .map((ability) => ability['ability']['name'] as String)
        .toList();

    return PokeModel(
      id: basicModel.id,
      name: basicModel.name,
      url: basicModel.url,
      types: types,
      height: json['height'],
      weight: json['weight'],
      stats: stats,
      abilities: abilities, // ✅ Las asignamos aquí
    );
  }

  /// Método opcional para capitalizar el nombre
  static String _capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
