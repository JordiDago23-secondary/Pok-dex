import 'package:flutter/material.dart';
import 'package:pokedex/Model/pokemon_model.dart';

class CardPokemon extends StatelessWidget {
  final PokeModel pokemon;
  final bool isFavorite;
  final VoidCallback onTapFavorite;
  final VoidCallback onTap;

  CardPokemon({
    required this.pokemon,
    required this.isFavorite,
    required this.onTapFavorite,
    required this.onTap,
  });

  Color _getColorByType(String type) {
    switch (type) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.greenAccent;
      case 'electric':
        return Colors.yellowAccent;
      case 'psychic':
        return Colors.purpleAccent;
      case 'normal':
        return Colors.grey;
      case 'ice':
        return Colors.cyanAccent;
      case 'fighting':
        return Colors.orangeAccent;
      case 'poison':
        return Colors.deepPurpleAccent;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.indigoAccent;
      case 'bug':
        return Colors.lightGreenAccent;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurple;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black54;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal';
    Color bgColor = _getColorByType(type);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'pokemon-${pokemon.id}',
              child: Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              pokemon.name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types.map((type) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )).toList(),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: onTapFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
