import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/Controller/pokemon_api.dart';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:pokedex/Page/pokemon_detail_page.dart';
import 'package:pokedex/Widgets/poke_card.dart';

import '../Controller/favorite_controller.dart';
import '../Services/notification_service.dart';
import '../Widgets/poke_card2.dart';

class InitialPage extends StatefulWidget {

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const InitialPage({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final PokeApi pokeApi = PokeApi();

  List<PokeModel> allPokemons = [];
  List<PokeModel> _foundPokemons = [];
  List<int> _favoritePokemons = [];

  int numOffSet = 0;
  int numPokn = 1500;

  bool isGridView = true;
  bool showOnlyFavorites = false;
  //bool isDarkMode = false;
  bool isOrderByA_Z = false;
  bool isOrderBy0_9 = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    updatePokemon();
  }

  // ✅ Carga favoritos desde el controller
  void _loadFavorites() async {
    _favoritePokemons = await FavoriteController.getFavoritePokemons();
    setState(() {});
  }

  // ✅ Alterna el favorito y muestra la notificación
  void _toggleFavorite(PokeModel pokemon) async {
    await FavoriteController.toggleFavorite(pokemon.id);
    final isNowFavorite = await FavoriteController.isFavorite(pokemon.id);

    _showFavoriteNotification(pokemon, isNowFavorite);
    _loadFavorites();
  }

  // ✅ Muestra notificación y SnackBar al usuario
  void _showFavoriteNotification(PokeModel pokemon, bool isNowFavorite) {
    NotificationService.showNotification(
      title: isNowFavorite ? '¡Favorito añadido!' : 'Favorito eliminado',
      body: isNowFavorite
          ? '¡${pokemon.name} ahora es tu favorito!'
          : '¡${pokemon.name} ya no es tu favorito!',
    );

    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNowFavorite
            ? '${pokemon.name} añadido a favoritos'
            : '${pokemon.name} eliminado de favoritos'),
        duration: Duration(milliseconds: 800),
      ),
    );*/
  }

  // ✅ Actualiza toda la lista de pokémons
  void updatePokemon() async {
    List<PokeModel> Pokemons =
    await PokeApi().getAllPokemons(offset: numOffSet, nomPok: numPokn);
    setState(() {
      allPokemons = Pokemons;
      _foundPokemons = Pokemons;
    });
  }

  // ✅ Filtro de búsqueda por texto (mejorado con startsWith)
  void run_Filter(String keyword) {
    List<PokeModel> results = [];

    if (keyword.isEmpty) {
      results = allPokemons;
    } else {
      results = allPokemons
          .where((poke) => poke.name
          .toLowerCase()
          .startsWith(keyword.toLowerCase())) // Aquí el cambio clave
          .toList();
    }

    setState(() {
      _foundPokemons = results;
    });
  }

  void orderPokemonsAlphabetically() {
    setState(() {
      if (isOrderByA_Z) {
        _foundPokemons.sort((a, b) => a.name.compareTo(b.name));
      } else {
        _foundPokemons.sort((a, b) => b.name.compareTo(a.name));
      }
    });
  }

  void orderPokemonsByNumber() {
    setState(() {
      if (isOrderBy0_9) {
        _foundPokemons.sort((a, b) => a.id.compareTo(b.id));
      } else {
        _foundPokemons.sort((a, b) => b.id.compareTo(a.id));
      }
    });
  }

  void filterByType(String type) {
    List<PokeModel> results = [];

    if (type == 'Todos') {
      results = allPokemons;
    } else {
      final englishType = typeTranslations[type] ?? type.toLowerCase();

      results = allPokemons.where((poke) {
        return poke.types.any((t) => t.toLowerCase() == englishType);
      }).toList();
    }

    setState(() {
      selectedType = type;
      _foundPokemons = results;
      if (isOrderByA_Z) {
        orderPokemonsAlphabetically(); // Si ya está activado el orden
      }
    });
  }


  Map<String, String> typeTranslations = {
    'Todos': 'all',
    'Agua': 'water',
    'Fuego': 'fire',
    'Planta': 'grass',
    'Eléctrico': 'electric',
    'Volador': 'flying',
    'Veneno': 'poison',
    'Tierra': 'ground',
    'Roca': 'rock',
    'Psíquico': 'psychic',
    'Hielo': 'ice',
    'Bicho': 'bug',
    'Dragón': 'dragon',
    'Fantasma': 'ghost',
    'Siniestro': 'dark',
    'Acero': 'steel',
    'Hada': 'fairy',
    'Normal': 'normal',
    'Lucha': 'fighting',
  };


  List<String> types = [
    'Todos',
    'Agua',
    'Fuego',
    'Planta',
    'Eléctrico',
    'Volador',
    'Veneno',
    'Tierra',
    'Roca',
    'Psíquico',
    'Hielo',
    'Bicho',
    'Dragón',
    'Fantasma',
    'Siniestro',
    'Acero',
    'Hada',
    'Normal',
    'Lucha',
  ];

  String selectedType = 'Todos'; // Tipo seleccionado

  // ✅ Devuelve los pokémons que se deben mostrar en el listado
  List<PokeModel> _getPokemonsToShow() {
    if (showOnlyFavorites) {
      return _foundPokemons
          .where((poke) => _favoritePokemons.contains(poke.id))
          .toList();
    } else {
      return _foundPokemons;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PokeModel> pokemonsToShow = _getPokemonsToShow();

    return Scaffold(
      //backgroundColor: Colors.red[600],
      backgroundColor: Colors.red[600],
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pokédex',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Pokemon',
                ),
              ),
              Row(
                children: [
                  //Ordenar por numero de Pokedex
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOrderBy0_9 = !isOrderBy0_9;
                        isOrderByA_Z = false;
                      });
                      orderPokemonsByNumber();
                    },
                    icon: Icon(
                      isOrderBy0_9
                          ? Icons.format_list_numbered
                          : Icons.swap_vert,
                    ),
                  ),
                  // Boton para ordenar alfabeticamente
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOrderByA_Z = !isOrderByA_Z;
                        isOrderBy0_9 = false;
                      });
                      orderPokemonsAlphabetically();
                    },
                    icon: Icon(
                      isOrderByA_Z
                          ? Icons.filter_list_outlined
                          : Icons.filter_list_off_rounded,
                    ),
                  ),
                  // Botón para mostrar solo favoritos
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showOnlyFavorites = !showOnlyFavorites;
                      });
                    },
                    icon: Icon(
                      showOnlyFavorites
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                  ),
                  // Botón para cambiar vista
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                    },
                    icon: Icon(
                      isGridView
                          ? Icons.grid_view_outlined
                          : Icons.view_list,
                    ),
                  ),
                  // Botón para cambiar modo claro/oscuro (para el futuro)
                  IconButton(
                    onPressed: widget.onToggleTheme,
                    icon: Icon(
                      widget.isDarkMode ? Icons.dark_mode_sharp : Icons.light_mode,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    cursorColor: Colors.black,
                    onChanged: run_Filter, // Pasa directamente la función
                    decoration: InputDecoration(
                      labelText: 'Buscar Pokémons',
                      hintText: 'Escribe un nombre...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];
                    final isSelected = selectedType == type;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.redAccent, // Color de seleccionado
                        backgroundColor: Colors.grey[300], // Color de no seleccionado
                        onSelected: (_) {
                          filterByType(type);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: pokemonsToShow.isEmpty
                  ? Center(
                child: Text(
                  'No hay Pokémon para mostrar',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : isGridView
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  itemCount: pokemonsToShow.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    final poke = pokemonsToShow[index];
                    return CardPokemon(
                      pokemon: poke,
                      isFavorite: _favoritePokemons.contains(poke.id),
                      onTapFavorite: () => _toggleFavorite(poke),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailPage(
                              pokemon: poke,
                              isFavorite: _favoritePokemons
                                  .contains(poke.id),
                              onTapFavorite: (id) {
                                final selectedPoke =
                                _foundPokemons.firstWhere(
                                      (p) => p.id == id,
                                  orElse: () => poke,
                                );
                                _toggleFavorite(selectedPoke);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
                  : ListView.builder(
                itemCount: pokemonsToShow.length,
                itemBuilder: (context, index) {
                  final poke = pokemonsToShow[index];
                  return CardPokemon(
                    pokemon: poke,
                    isFavorite: _favoritePokemons.contains(poke.id),
                    onTapFavorite: () => _toggleFavorite(poke),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PokemonDetailPage(
                            pokemon: poke,
                            isFavorite:
                            _favoritePokemons.contains(poke.id),
                            onTapFavorite: (id) {
                              final selectedPoke =
                              _foundPokemons.firstWhere(
                                    (p) => p.id == id,
                                orElse: () => poke,
                              );
                              _toggleFavorite(selectedPoke);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
