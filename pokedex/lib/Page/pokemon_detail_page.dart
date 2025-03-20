import 'package:flutter/material.dart';
import 'package:pokedex/Model/pokemon_model.dart'; // Tu modelo aquí
import '../Controller/favorite_controller.dart';
import '../Services/notification_service.dart';

class PokemonDetailPage extends StatefulWidget {
  final PokeModel pokemon;
  final bool isFavorite;
  final Function(int) onTapFavorite;

  const PokemonDetailPage({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onTapFavorite,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite; // Inicializamos el valor
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    widget.onTapFavorite(widget.pokemon.id);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[600],
      appBar: AppBar(
        title: Text(widget.pokemon.name.toUpperCase(), style: TextStyle(color: Colors.black,)),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: _toggleFavorite,//_toggleFavorite
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Hero(
                tag: 'pokemon-${widget.pokemon.id}',
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${widget.pokemon.id}.gif',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'asset/images/no_imagen.png', // Ruta de tu asset
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '#${widget.pokemon.id} ${widget.pokemon.name.toUpperCase()}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16.0),
            _buildTypes(widget.pokemon.types),
            SizedBox(height: 16.0),
            _buildInfoRow('Altura:', '${widget.pokemon.height / 10} m'),
            _buildInfoRow('Peso:', '${widget.pokemon.weight / 10} kg'),
            SizedBox(height: 16.0),
            _buildAbilities(widget.pokemon.abilities),
            SizedBox(height: 16.0),
            Expanded(child: _buildStats(widget.pokemon.stats)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypes(List<String> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types.map((type) => _typeChip(type)).toList(),
    );
  }

  Widget _typeChip(String type) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }

  Widget _buildAbilities(List<String> abilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Habilidades:', style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 8.0),
        Column(
          children: abilities
              .map((ability) => Row(
            children: [
              Icon(Icons.check, color: Colors.white, size: 18),
              SizedBox(width: 8.0),
              Text(
                ability,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStats(Map<String, int> stats) {
    return ListView(
      children: stats.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.key}: ${entry.value}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 4.0),
            LinearProgressIndicator(
              value: entry.value / 100,
              backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
            SizedBox(height: 12.0),
          ],
        );
      }).toList(),
    );
  }
}
