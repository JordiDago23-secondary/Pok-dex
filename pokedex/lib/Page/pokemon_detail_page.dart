import 'package:flutter/material.dart';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:just_audio/just_audio.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokeModel pokemon;
  final bool isFavorite;
  final Function(int) onTapFavorite;
  final bool isDarkMode;

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onTapFavorite,
    required this.isDarkMode,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late bool _isFavorite;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool isShine = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;

    // Escuchamos el estado del reproductor para saber cuándo deja de sonar
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final isCompleted = playerState.processingState == ProcessingState.completed;

      setState(() {
        _isPlaying = isPlaying;
      });

      if (isCompleted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Cierra el reproductor al salir
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onTapFavorite(widget.pokemon.id);
  }

  void _playCry() async {
    try {
      await _audioPlayer.stop(); // Detiene cualquier reproducción anterior
      await _audioPlayer.setUrl(widget.pokemon.soundUrl);
      await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reproducir el sonido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    //final typeColor = _getColorByType(widget.pokemon.types.first);
    final typeColors = widget.pokemon.types.map((type) => _getColorByType(type)).toList();

    //  Paleta dinámica
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
          'Pokédex',
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
      body: Stack(
        children: [
          Column(
            children: [
              // Imagen y encabezado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: typeColors.length > 1
                      ? LinearGradient(
                    colors: [
                      typeColors[0].withOpacity(0.8),
                      typeColors[1].withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null,
                  color: typeColors.length == 1
                      ? typeColors[0].withOpacity(0.8)
                      : null,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isShine = !isShine;
                            });
                          },
                          child: Hero(
                          tag: 'pokemon-${widget.pokemon.id}',
                            //Links de imagenes
                            //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png'
                            //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',

                            //'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/${widget.pokemon.id}.png',
                            // 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',
                            child:Image.network( isShine?
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/${widget.pokemon.id}.png' :
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png',
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
                    // Icono con animación en la esquina superior derecha
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _playCry,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Datos del Pokémon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeightHeight(label: 'Weight', value: '${widget.pokemon.weight / 10} Kg', icon: Icons.fitness_center_outlined, textColor: textColor, subTextColor: subTextColor),
                    _buildWeightHeight(label: 'Height', value: '${widget.pokemon.height / 10} M',  icon: Icons.straighten, textColor: textColor, subTextColor: subTextColor),
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
        ],
      ),
    );
  }

  Widget _buildWeightHeight({
    required String label,
    required String value,
    required IconData icon,
    required Color textColor,
    required Color subTextColor
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 20,
            ),
            SizedBox(width: 5,),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
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
