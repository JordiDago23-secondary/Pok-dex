import 'package:flutter/material.dart';
import 'package:pokedex/Model/pokemon_model.dart';

class ListTilePokemon extends StatelessWidget {
  final PokeModel pokemon;
  final bool isFavorite;
  final VoidCallback onTapFavorite;
  final VoidCallback onTap;

  ListTilePokemon({
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
        return Colors.amberAccent;
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
    Color baseColor = _getColorByType(type);

    // Neon color tweaks
    final neonColor = baseColor.withOpacity(0.8);
    final hsl = HSLColor.fromColor(baseColor);
    final darkerColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();

    // For the glow effect
    final glowColor = baseColor.withOpacity(0.6);

    // Neon style text color
    final textColor = Colors.white.withOpacity(0.9);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              neonColor.withOpacity(0.4),
              darkerColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: darkerColor.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
          border: Border.all(
            color: baseColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Imagen del Pokémon

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor,
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png'
                      //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'asset/images/no_imagen.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                ),


              const SizedBox(width: 16),

              // Información del Pokémon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del Pokémon
                    Text(
                      pokemon.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: glowColor,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Tipos de Pokémon
                    Wrap(
                      spacing: 8,
                      children: pokemon.types.map((type) {
                        final typeColor = _getColorByType(type);
                        final hsl = HSLColor.fromColor(typeColor);
                        final darkerColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                typeColor.withOpacity(0.8),
                                darkerColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: typeColor.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
                          ),
                          child: Text(
                            type.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Botón de favorito
              IconButton(
                onPressed: onTapFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white.withOpacity(0.7),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
