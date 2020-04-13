import 'package:movieapp/models/trailer_model.dart';

class FavouriteTrailer {
  List<Trailer> results = [];

  FavouriteTrailer.fromJson(List<TResult> json) {
    List<Trailer> temp = [];
    for (var i = 0; i < json.length; i++) {
      Trailer d = Trailer(json[i].name, json[i].key);
      temp.add(d);
    }
    results = temp;
  }
}

class Trailer {
  int movie_id;
  String title;
  String link;

  Trailer(this.title, this.link);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['movie_id'] = movie_id;
    map['title'] = title;
    map['link'] = link;
    return map;
  }
}
