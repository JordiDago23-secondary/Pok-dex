import 'dart:convert';
import 'package:pokedex/Model/pokemon_model.dart';
import 'package:http/http.dart' as http;

class PokeApi {

  final apiUrl = 'https://pokeapi.co';


  Future<List<PokeModel>> getAllPokemons({int? nomPok, int? offset}) async {

    int numPokemon = nomPok ?? 20;
    int offSet = offset ?? 0;

    final response = await http.get(
        Uri.parse('$apiUrl/api/v2/pokemon?offset=$offSet&limit=$numPokemon'),
    );

    try{

      if(response.statusCode == 200){
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> results = jsonData['results'];
        return results.map((item) => PokeModel.fromJson(item)).toList();
      }else{
        throw Exception('Failed to load Pokedex');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}