import 'package:flutter/material.dart';
import 'package:pokedex/Controller/pokemon_api.dart';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:pokedex/Page/poke_widget.dart';


class InitialPage extends StatefulWidget{


  State<InitialPage> createState() => _InitialPageState();
}



class _InitialPageState extends State<InitialPage>{

  final PokeApi pokeApi = PokeApi();

  List<PokeModel> allPokemons = [];
  List<PokeModel> _foundPokemons = [];

  int numOffSet = 0;
  int numPokn = 200;

  void initState(){
    super.initState();
    updatePokemon();
  }

  void updatePokemon() async{

    List<PokeModel> Pokemons = await PokeApi().getAllPokemons(offset: numOffSet , nomPok: numPokn);
    setState((){
      allPokemons = Pokemons;
      _foundPokemons = Pokemons;
    });
  }

  void run_Filter(String KeyWord){

    List<PokeModel> results = [];

    if (KeyWord.isEmpty){
      results = allPokemons  ;
    }else{
      results = allPokemons.where((poke) =>
      poke.name.toLowerCase().contains(KeyWord.toLowerCase())).toList();
    }

    setState(() {
      _foundPokemons = results;
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.red[600],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pockédex',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
      ),

      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                cursorColor: Colors.black,
                onChanged: (value) => run_Filter(value),
                decoration: InputDecoration(
                  labelText: 'Buscar Pokémons',suffixIcon: Icon(Icons.search), suffixIconColor: Colors.grey,
                  hintText: 'Escribe un nombre ...',
                  //prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),




              ),

            ),
          ),

          Expanded(
            child: _foundPokemons.isEmpty?

                ListView.builder(
                  itemCount: allPokemons.length,
                  itemBuilder: (context, index) =>
                    PokeWidget(imag: 'https:raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${allPokemons[index].id}.png', name: allPokemons[index].name,),
                ) :

                ListView.builder(
                  itemCount: _foundPokemons.length,
                  itemBuilder: (context, index) =>
                      PokeWidget(imag: 'https:raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_foundPokemons[index].id}.png', name: _foundPokemons[index].name,),
                ),

          ),
        ],
      ),

    );
  }
}


//https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon[index].id}.png
//'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${pokemon[index].id}.gif'
