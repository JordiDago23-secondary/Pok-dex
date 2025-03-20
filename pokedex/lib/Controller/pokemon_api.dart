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

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokedex');
    }

    Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> results = jsonData['results'];


    List<PokeModel> basicPokemons = results.map((item) => PokeModel.fromJson(item)).toList();


    List<Future<PokeModel>> detailFutures = basicPokemons.map((poke) async {
      try {
        final detailResponse = await http.get(Uri.parse(poke.url));

        if (detailResponse.statusCode == 200) {
          Map<String, dynamic> detailJson = json.decode(detailResponse.body);
          return PokeModel.fromDetailJson(detailJson, poke);
        } else {
          // Si falla el detalle, retorna el básico
          return poke;
        }
      } catch (e) {
        // Error en el fetch, retorna el básico
        return poke;
      }
    }).toList();


    List<PokeModel> detailedPokemons = await Future.wait(detailFutures);

    return detailedPokemons;
  }
}
