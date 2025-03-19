import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pokedex/Controller/pokemon_api.dart';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:pokedex/Widgets/poke_widget.dart';
import 'package:pokedex/Widgets/poke_card.dart';
import 'package:pokedex/Widgets/poke_card2.dart';

class InitialPage extends StatefulWidget{

  State<InitialPage> createState() => _InitialPageState();
}


class _InitialPageState extends State<InitialPage>{

  final PokeApi pokeApi = PokeApi();

  List<PokeModel> allPokemons = [];
  List<PokeModel> _foundPokemons = [];


  int numOffSet = 0;
  int numPokn = 1500;
  bool isFavorite = true;

  bool isGridView = true;
  bool isDarck = true;
  bool isListFavorites = true;

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
        title: Padding(
          padding: const EdgeInsets.symmetric( vertical: 10),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pockédex',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontFamily: 'Pokemon',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      //IconButton para mostrar una lista de pokemons a los que se les a dado megusta guardar los pokemons con SharedPreferences
                      IconButton(
                          onPressed: () => setState(() { isListFavorites = !isListFavorites;}),
                          icon: isListFavorites? Icon(Icons.favorite_border): Icon(Icons.favorite)
                      ),
                      //IconButton para que el usuario escoga si ver la lista de pokemons en modo GridView or tipo lista con un ListTile con un ListView
                      IconButton(
                          onPressed: () => setState(() { isGridView = !isGridView;}),
                          icon: Icon(Icons.grid_view_outlined)
                      ),
                      //IconButton Para aplicar el modo oscuro y claro de la aplicacion
                      IconButton(
                          onPressed: () => setState(() { isDarck = !isDarck;}),
                          icon: isDarck? Icon(Icons.sunny): Icon(Icons.mode_night_sharp)
                      ),
                    ],
                  ),
                ],
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(90),
                //Extension del AppBar para añadir un TextField con la logica de un buscador de Pokemons.
                //"la logica de busqueda esta mal aplicada busca pokemons los contengan en sus nombres ciertas palabras no su nombre de inicio a fin"
                child: Container(
                  color: Colors.grey[200],
                  // Column para dentro introducir el TextField  y anadir una logica mas se trata de implementas
                  // un listView para crear unalisa en direccion horizontal y buscar los pokemons por tipo de elemento: Normal, fuego, agua, planta, electrico, etc...
                  // dicha lista estara devajo del TextField y se marcara como predionado dicho campo a la vez modificara los poquemos que se veran en la Lista dePokemos o el GridView
                  child: Column(
                    children: [
                      Padding(
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
                      SizedBox(height: 10,),
                      /*ListView.builder(
                          itemCount: ,
                          itemBuilder: (Context, index){

                          }
                      ),*/
                    ],
                  ),
                ),
        ),
      ),

      //Body donde se mostraran la lista de pokemons con los filtrados de megusta el tipo de pokemon "aplicado en el AppBar"
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: _foundPokemons.isEmpty?

                ListView.builder(
                  itemCount: allPokemons.length,
                  itemBuilder: (context, index) =>
                      PokeCard(imag: 'https:raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${allPokemons[index].id}.png', name: allPokemons[index].name, isFavorite: isFavorite,),
                ) :

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    itemCount: _foundPokemons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                      //childAspectRatio: 2/3,
                    ),
                    itemBuilder: (context, index) => CardPokemon(imag: 'https:raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_foundPokemons[index].id}.png', name: _foundPokemons[index].name, isFavorite: isFavorite,),

                            ),
                ),

          ),
        ],
      ),

    );
  }
}



//https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon[index].id}.png
//'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/${pokemon[index].id}.gif'
