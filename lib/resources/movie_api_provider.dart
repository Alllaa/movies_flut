import 'dart:convert';

import 'package:http/http.dart';
import 'package:movieapp/models/genre_model.dart';
import 'package:movieapp/models/item_model.dart';
import 'package:movieapp/models/trailer_model.dart';
abstract class MovieRepository
{
  Future<ItemModel> fetchMovieList(bool isRecent);
  Future<ItemModel> fetchPopularList(bool isRecent);
  Future<GenreModel> fetchGeneralList();
  Future<TrailerModel> fetchTrailerList(int id);

}
class MovieApiProvider implements MovieRepository{
  Client client = Client();
  final apikey = "7306fc3ca843fa9b34280a8f0f8d7b40";
    final baseUrl = "http://api.themoviedb.org/3/movie";

  @override
  Future<ItemModel> fetchMovieList(bool isRecent) async {
    print("Entered");
    final response = await client.get(baseUrl+"/now_playing?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body),isRecent);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<ItemModel> fetchPopularList(bool isRecent) async{
    print("Entered genres");
    final response = await client.get(baseUrl+"/popular?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body,),isRecent);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<GenreModel> fetchGeneralList() async{
    // TODO: implement fetchGeneralList
    print("Entered 2");
    final response = await client.get("http://api.themoviedb.org/3/genre/movie/list?api_key=$apikey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return GenreModel.fromJson(json.decode(response.body,));
    } else {
      throw Exception('Failed to load post');
    }
    return null;
  }

  @override
  Future<TrailerModel> fetchTrailerList(int id) async{
    print("Enter Trailer + ${id.toString()}") ;
    final response = await client.get(baseUrl+'/'+id.toString()+"/videos?api_key=$apikey");
    print("Allaskjdkjsddj"+response.body.toString());
    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
class NetworkError extends Error {}