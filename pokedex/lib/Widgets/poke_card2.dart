import 'package:flutter/material.dart';

class CardPokemon extends StatefulWidget{

  String name = '';
  String imag = '';
  bool isFavorite = true;

  CardPokemon({
    super.key,
    required this.name,
    required this.imag,
    required this.isFavorite
  });

  _CardPokemonState createState() => _CardPokemonState();
}


class _CardPokemonState extends State<CardPokemon>{

  late bool _isFavorite;

  void initState(){
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  Widget build(BuildContext){
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(width: 1.5),
      ),

      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Flexible(
               flex: 7,
               child: AspectRatio(
                 aspectRatio: 1,
                 child: Center(
                    child: Image.network(widget.imag)),
               ),
             ),

            SizedBox(height: 5,),

            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.name, style: TextStyle(
                      //fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() { _isFavorite = !_isFavorite; }),
                    icon: _isFavorite ? Icon(Icons.favorite_border_outlined) : Icon(Icons.favorite),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

}


//setState(() { _isFavorite = !_isFavorite; })