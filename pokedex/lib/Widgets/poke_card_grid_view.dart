import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    Color baseColor = _getColorByType(type);

    final hsl = HSLColor.fromColor(baseColor);
    final darkerBorder = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();

    // Texto legible (gris claro)
    final textColor = Colors.grey[200];
    final glowColor = baseColor.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: baseColor.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(width: 1.5, color: darkerBorder),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Botón de favorito alineado arriba a la derecha
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: darkerBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 1),
                        child: Text('#${pokemon.id.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white, //textColor
                        size: 22,
                      ),
                      onPressed: onTapFavorite,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(), // Reduce tamaño del botón
                    ),
                  ],
                ),
              ),

              // Imagen del Pokémon (Hero animation)
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor,
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png'
                      //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                        fit: BoxFit.contain,

                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                          if(loadingProgress == null){
                            return child;
                          }else{
                            return Center(
                              child: Lottie.asset('asset/animations/AnimationPokeball.json',
                                height: 150,
                                width: 150,
                                repeat: true,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('asset/images/no_imagen.png', fit: BoxFit.contain,);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Nombre del Pokémon
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    pokemon.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Tipos de Pokémon
              Expanded(
                flex: 2,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: pokemon.types.map((type) {
                    final typeColor = _getColorByType(type);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}