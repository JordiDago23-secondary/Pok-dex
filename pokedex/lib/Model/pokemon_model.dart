class PokeModel {
  final int id;
  final String name;
  final String url;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;
  final List<String> abilities;
  final String soundUrl;

  PokeModel({
    required this.id,
    required this.name,
    required this.url,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.soundUrl,
  });

  factory PokeModel.fromJson(Map<String, dynamic> json) {
    final uri = Uri.parse(json['url']);
    final id = int.parse(uri.pathSegments[uri.pathSegments.length - 2]);

    final soundUrl = 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/$id.ogg';
    //'https://pokemoncries.com/cries-old/$id.mp3'

    return PokeModel(
      id: id,
      name: _capitalize(json['name']),
      url: json['url'],
      types: [],
      height: 0,
      weight: 0,
      stats: {},
      abilities: [],
      soundUrl: soundUrl,
    );
  }

  factory PokeModel.fromDetailJson(Map<String, dynamic> json, PokeModel basicModel) {
    List<String> types = (json['types'] as List)
        .map((type) => type['type']['name'] as String)
        .toList();

    Map<String, int> stats = {};
    (json['stats'] as List).forEach((stat) {
      stats[stat['stat']['name']] = stat['base_stat'];
    });

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
      abilities: abilities,
      soundUrl: basicModel.soundUrl,
    );
  }

  static String _capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
