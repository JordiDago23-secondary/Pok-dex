import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/Controller/pokemon_api.dart';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:pokedex/Page/pokemon_detail_page.dart';
import 'package:pokedex/Widgets/poke_card_list_tile.dart';

import '../Controller/favorite_controller.dart';
import '../Services/notification_service.dart';
import '../Widgets/poke_card_grid_view.dart';
import 'package:pokedex/ModeDark_ModeLight/theme_dark.dart';
import 'package:pokedex/ModeDark_ModeLight/theme_light.dart';

enum OrderType {
  none,
  alphabetical,
  numerical,
}

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
  int numPokn = 10000;

  bool isGridView = true;
  bool showOnlyFavorites = false;

  //bool isDarkMode = false;
  bool isOrderByA_Z = false;
  bool isOrderBy0_9 = true;

  //estado de carga pokemons
  bool isLoading = false;

  //buscar por tipos de Pokémons
  String selectedType = 'Todos';
  String searchKeyword = '';

  //enum que lleva elestado de los botones de ordenar
  // en orden alfabetico o numerico
  OrderType _orderType = OrderType.none;
  bool _isAscending = true;

  //variable en referencia a la conexión en internet
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    updatePokemon();

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.any((result) => result == ConnectivityResult.none)) {
        setState(() {
          _hasInternet = false;
        });
      } else {
        setState(() {
          _hasInternet = true;
        });
      }
    });
  }

  //Carga favoritos desde el controller
  void _loadFavorites() async {
    _favoritePokemons = await FavoriteController.getFavoritePokemons();
    setState(() {});
  }

  void sortPokemons() {
    setState(() {
      if (_orderType == OrderType.alphabetical) {
        _foundPokemons.sort((a, b) =>
            _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
      } else if (_orderType == OrderType.numerical) {
        _foundPokemons.sort((a, b) =>
            _isAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
      }
      // Si es OrderType.none, no hace nada (se pueden definir comportamientos de ser necesarios)
    });
  }

  //Alterna el favorito y muestra la notificación
  void _toggleFavorite(PokeModel pokemon) async {
    final wasFavorite = _favoritePokemons.contains(pokemon.id);
    await FavoriteController.toggleFavorite(pokemon.id);

    setState(() {
      if (wasFavorite) {
        _favoritePokemons.remove(pokemon.id); // Eliminado directamente
      } else {
        _favoritePokemons.add(pokemon.id); // Añadido directamente
      }
      if (showOnlyFavorites) {
        applyFilters();
      }
    });

    _showFavoriteNotification(pokemon, !wasFavorite);
  }

  // Muestra notificación y SnackBar al usuario
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

  // Actualiza toda la lista de pokémons
  void updatePokemon() async {
    setState(() {
      isLoading = true;
    });

    List<PokeModel> Pokemons =
        await PokeApi().getAllPokemons(offset: numOffSet, nomPok: numPokn);
    setState(() {
      allPokemons = Pokemons;
      _foundPokemons = Pokemons;
      isLoading = false;
    });
  }

  //Mostrar un pokemon aleatorio en Page pokemon_datail_page.dart
  void navigateToRandomPokemon() {
    if (allPokemons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todavía no se han cargado los Pokémon.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final random = Random();
    final randomIndex = random.nextInt(allPokemons.length);
    final randomPokemon = allPokemons[randomIndex];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PokemonDetailPage(
          pokemon: randomPokemon,
          isFavorite: _favoritePokemons.contains(randomPokemon.id),
          onTapFavorite: (id) {
            final selectedPoke = _foundPokemons.firstWhere(
              (p) => p.id == id,
              orElse: () => randomPokemon,
            );
            _toggleFavorite(selectedPoke);
          },
          isDarkMode: widget.isDarkMode,
        ),
      ),
    ).then((_) {
      // Cuando vuelves de la página de detalles
      applyFilters();
    });
  }

  void applyFilters() {
    List<PokeModel> filteredPokemons = allPokemons;

    if (selectedType != 'Todos') {
      final englishType =
          typeTranslations[selectedType] ?? selectedType.toLowerCase();

      filteredPokemons = filteredPokemons.where((poke) {
        return poke.types.any((t) => t.toLowerCase() == englishType);
      }).toList();
    }

    if (searchKeyword.isNotEmpty) {
      filteredPokemons = filteredPokemons.where((poke) {
        return poke.name.toLowerCase().startsWith(searchKeyword.toLowerCase());
      }).toList();
    }

    if (showOnlyFavorites) {
      filteredPokemons = filteredPokemons.where((poke) {
        return _favoritePokemons.contains(poke.id);
      }).toList();
    }

    setState(() {
      _foundPokemons = filteredPokemons;
    });

    // Siempre ordena después de aplicar los filtros
    sortPokemons();
  }

  // Filtro de búsqueda por texto (mejorado con startsWith)
  void run_Filter(String keyword) {
    List<PokeModel> results = [];

    setState(() {
      searchKeyword = keyword;
    });
    applyFilters();
  }

  void filterByType(String type) {
    List<PokeModel> results = [];

    setState(() {
      selectedType = type;
      searchKeyword = '';
    });
    applyFilters();
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

  //Devuelve los pokémons que se deben mostrar en el listado
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<PokeModel> pokemonsToShow = _getPokemonsToShow();

    return Scaffold(
      backgroundColor: colorScheme.primary,
      //colorScheme.primary // black87 // black26
      appBar: AppBar(
        elevation: 4,
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        // Fondo del AppBar
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Pokédex',
                  style: textTheme.titleLarge?.copyWith(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    // Color del texto
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'Pokemon',
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: navigateToRandomPokemon,
                    icon: Icon(
                      Icons.casino,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_orderType == OrderType.alphabetical) {
                          // Cambia el sentido del orden
                          _isAscending = !_isAscending;
                        } else {
                          _orderType = OrderType.alphabetical;
                          _isAscending =
                              true; // O el valor que prefieras por defecto
                        }
                      });
                      sortPokemons();
                    },
                    icon: Icon(
                      _orderType == OrderType.alphabetical
                          ? (_isAscending
                              ? Icons.sort_by_alpha
                              : Icons.sort_by_alpha_outlined)
                          : Icons.filter_list_off_rounded,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showOnlyFavorites = !showOnlyFavorites;
                      });
                      applyFilters();
                    },
                    icon: Icon(
                      showOnlyFavorites
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isDarkMode
                          ? Colors.white
                          : Colors
                              .black, // Esto lo puedes dejar así porque siempre es rojo
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                    },
                    icon: Icon(
                      isGridView ? Icons.grid_view_outlined : Icons.view_list,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onToggleTheme,
                    icon: Icon(
                      widget.isDarkMode
                          ? Icons.dark_mode_sharp
                          : Icons.light_mode,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          run_Filter(query);
                        },
                        decoration: InputDecoration(
                          labelText: 'Buscar Pokémon',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // Espacio entre el campo y el botón
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_orderType == OrderType.numerical) {
                            // Cambia el sentido del orden
                            _isAscending = !_isAscending;
                          } else {
                            _orderType = OrderType.numerical;
                            _isAscending =
                                true; // O el valor que prefieras por defecto
                          }
                        });
                        sortPokemons();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor:
                            widget.isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            width: 1,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      icon: Icon(
                        _orderType == OrderType.numerical
                            ? (_isAscending
                                ? Icons.format_list_numbered
                                : Icons.swap_vert)
                            : Icons.filter_list_off_rounded,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.secondary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: colorScheme.primary,
                        backgroundColor:
                            colorScheme.surfaceVariant ?? Colors.grey[300],
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
        child: !_hasInternet
            ? Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 1.5, color: Colors.grey),
                  ),
                  color: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '🛜📡📶 No hay conexión a Internet. Inténtelo más tarde.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : isLoading
                ? Center(
                    child: Lottie.asset(
                      'asset/animations/AnimationPokeball.json',
                      height: 150,
                      width: 150,
                      repeat: true,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      updatePokemon(); // Llama a la API nuevamente
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is OverscrollNotification &&
                            scrollNotification.overscroll < -30) {
                          // Usuario ha llegado al tope superior y sigue intentando desplazarse arriba
                          updatePokemon(); // Recarga los datos
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: pokemonsToShow.isEmpty
                                ? Center(
                                    child: Text(
                                      'No hay Pokémon para mostrar',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  )
                                : isGridView
                                    ? GridView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        // Permite hacer pull-to-refresh
                                        itemCount: pokemonsToShow.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 4,
                                        ),
                                        itemBuilder: (context, index) {
                                          final poke = pokemonsToShow[index];
                                          return CardPokemon(
                                            pokemon: poke,
                                            isFavorite: _favoritePokemons
                                                .contains(poke.id),
                                            onTapFavorite: () =>
                                                _toggleFavorite(poke),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      PokemonDetailPage(
                                                    pokemon: poke,
                                                    isFavorite:
                                                        _favoritePokemons
                                                            .contains(poke.id),
                                                    onTapFavorite: (id) {
                                                      final selectedPoke =
                                                          _foundPokemons
                                                              .firstWhere(
                                                        (p) => p.id == id,
                                                        orElse: () => poke,
                                                      );
                                                      _toggleFavorite(
                                                          selectedPoke);
                                                    },
                                                    isDarkMode:
                                                        widget.isDarkMode,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        // Permite pull-to-refresh
                                        itemCount: pokemonsToShow.length,
                                        itemBuilder: (context, index) {
                                          final poke = pokemonsToShow[index];
                                          return ListTilePokemon(
                                            pokemon: poke,
                                            isFavorite: _favoritePokemons
                                                .contains(poke.id),
                                            onTapFavorite: () =>
                                                _toggleFavorite(poke),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      PokemonDetailPage(
                                                    pokemon: poke,
                                                    isFavorite:
                                                        _favoritePokemons
                                                            .contains(poke.id),
                                                    onTapFavorite: (id) {
                                                      final selectedPoke =
                                                          _foundPokemons
                                                              .firstWhere(
                                                        (p) => p.id == id,
                                                        orElse: () => poke,
                                                      );
                                                      _toggleFavorite(
                                                          selectedPoke);
                                                    },
                                                    isDarkMode:
                                                        widget.isDarkMode,
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
                  ),
      ),
    );
  }
}
