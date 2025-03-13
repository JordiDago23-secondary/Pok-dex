import 'package:flutter/material.dart';


class PokeWidget extends StatelessWidget{

  String name = '';
  String imag = '';
  PokeWidget({required this.name, required this.imag});

  Widget build(BuildContext context){
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),

        ),
        margin:EdgeInsets.symmetric(horizontal: 20, vertical: 8),

        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          hoverColor: Colors.white,
          leading: Image.network('$imag',),
          title: Text('$name', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),),
        ),

    );
  }

}