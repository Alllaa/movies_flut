import 'package:equatable/equatable.dart';

class GenreModel extends Equatable {
  List<Result> results = [];

  GenreModel.fromJson(Map<String, dynamic> parsedJson) {
    List<Result> temp = [];
    for (var i = 0; i < parsedJson['genres'].length; i++) {
      Result result = Result(parsedJson['genres'][i]);
      temp.add(result);
    }
    temp = temp.toSet().toList();
    results = temp;
  }
  List<Result>get getGenres => results;

  String getGenre(List<int> ids)
  {
    ids = ids.toSet().toList();
    String mygenre = "";
    for(var i = 0; i< ids.length; i++)
      {
        mygenre += results.where((user) =>user.id == ids[i]).first.name + ", ";
      }
    mygenre = mygenre.substring(0,mygenre.length);
    return mygenre;
  }

  @override
  // TODO: implement props
  List<Object> get props => [results];
}

class Result extends Equatable {
  int id;
  String name ;

  Result(result) {
    name = result['name'].toString();
    id = result['id'];

  }

  String get get_name => name;
  int get get_id => id;


  @override
  // TODO: implement props
  List<Object> get props => [
    name,
    id,
  ];
}
