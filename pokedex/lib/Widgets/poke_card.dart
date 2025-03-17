import 'package:flutter/material.dart';

class PokeCard extends StatefulWidget{

  String name = '';
  String imag = '';
  bool isFavorite = true;

  PokeCard({
    super.key,
    required this.name,
    required this.imag,
    required this.isFavorite,
  });


  _PokeCardState createState() => _PokeCardState();
}




class _PokeCardState extends State<PokeCard>{



  Widget build(BuildContext context){
    return Card(

      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(width: 1.5),
      ),

      margin:EdgeInsets.symmetric(horizontal: 20, vertical: 8),

      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        hoverColor: Colors.white,
        leading: Image.network(widget.imag,scale: 1,),
        trailing: IconButton(onPressed: () => setState((){widget.isFavorite = !widget.isFavorite;}), icon: widget.isFavorite?  Icon(Icons.favorite_border_outlined) : Icon(Icons.favorite)),
        title: Text(widget.name, style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),),
      ),

    );
  }

}