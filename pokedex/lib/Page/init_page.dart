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
  bool isDarkMode = false;

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
      backgroundColor: Colors.red[600],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
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
                  fontSize: 40,
                  fontFamily: 'Pokemon',
                ),
              ),
              Row(
                children: [
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
                    onPressed: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                    icon: Icon(
                      isDarkMode ? Icons.dark_mode_sharp : Icons.light_mode,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: Container(
            color: Colors.grey[200],
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
        ),
      ),
      body: Column(
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
    );
  }
}
