
class PokeModel{

  int id;
  String name;
  String url;

  PokeModel ({
    required this.id,
    required this.name,
    required this.url,
  });

  factory PokeModel.fromJson(Map<String, dynamic> json){

    final uri = Uri.parse(json['url']);
    final id = int.parse(uri.pathSegments[uri.pathSegments.length - 2]);

    return PokeModel(
        id: id,
        name: json['name'],
        url: json['url'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'url' : url,
    };
  }


}