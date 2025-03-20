import 'package:flutter/material.dart';
import 'package:pokedex/Model/pokemon_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokeModel pokemon;
  final bool isFavorite;
  final Function(int) onTapFavorite;
  final bool isDarkMode; // 👈 NUEVO parámetro

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onTapFavorite,
    required this.isDarkMode, // 👈 nuevo requerido
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onTapFavorite(widget.pokemon.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    // 🎨 Paleta dinámica
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final appBarColor = backgroundColor;
    final primaryColor = isDarkMode ? Colors.orangeAccent : Colors.orange[300]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final cardBackground = isDarkMode ? Colors.grey[850]! : Colors.white;
    final statBarBackground = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: Text(
          'Pokedex',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(_isFavorite),
                  color: Colors.redAccent,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Imagen y encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'pokemon-${widget.pokemon.id}',
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',
                    //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${widget.pokemon.id}.gif',
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'asset/images/no_imagen.png',
                        height: 120,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.pokemon.name.toLowerCase(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTypes(widget.pokemon.types),
              ],
            ),
          ),

          // Datos del Pokémon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildWeightHeight('Weight', '${widget.pokemon.weight / 10} KG', textColor, subTextColor),
                _buildWeightHeight('Height', '${widget.pokemon.height / 10} M', textColor, subTextColor),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Base Stats Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Base Stats',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Stats
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStats(widget.pokemon.stats, textColor, statBarBackground),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightHeight(String label, String value, Color textColor, Color subTextColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: subTextColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTypes(List<String> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types.map((type) => _typeChip(type)).toList(),
    );
  }

  Widget _typeChip(String type) {
    Color color = _getColorByType(type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStats(Map<String, int> stats, Color textColor, Color barBackgroundColor) {
    return ListView(
      children: stats.entries.map((entry) {
        Color progressColor = _getStatColor(entry.key);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y valor
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  Text(
                    entry.value.toString(),
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Barra de progreso
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (entry.value / 300).clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: barBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.greenAccent;
      case 'electric':
        return Colors.yellow[700]!;
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
        return Colors.brown;
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

  Color _getStatColor(String stat) {
    switch (stat.toLowerCase()) {
      case 'hp':
        return Colors.redAccent;
      case 'attack':
        return Colors.orange;
      case 'defense':
        return Colors.blue;
      case 'special-attack':
        return Colors.deepOrange;
      case 'special-defense':
        return Colors.green;
      case 'speed':
        return Colors.lightBlueAccent;
      default:
        return Colors.grey;
    }
  }
}
