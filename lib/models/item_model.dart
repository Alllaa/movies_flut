import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  int page;
  int total_page;
  int total_results;
  List<Result> results = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson,bool isRecent) {
    page = parsedJson['page'];
    total_page = parsedJson['total_pages'];
    total_results = parsedJson['total_results'];
    List<Result> temp = [];
    for (var i = 0; i < parsedJson['results'].length; i++) {
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }
    if(!isRecent)
      {
        temp.sort((a,b)
        {
          return b.popularity.compareTo(a.popularity);
        });
      }else
        {
          temp.sort((a,b)
          {
            return DateTime.parse(b.release_date).compareTo(DateTime.parse(a.release_date));
          });
        }
    results = temp;
  }

  @override
  // TODO: implement props
  List<Object> get props => [page, total_page, total_results, results];
}

class Result extends Equatable {
  String vote_count;
  int id;
  bool video;
  String vote_average;
  String title;
  double popularity;
  String poster_path;
  List<int> genre_ids = [];
  String backdrop_path;
  bool adult;
  String overview;
  String release_date;

  Result(result) {
    vote_count = result['vote_count'].toString();
    id = result['id'];
    video = result['video'];
    vote_average = result['vote_average'].toString();
    title = result['title'].toString();
    popularity = result['popularity'];
    poster_path = "http://image.tmdb.org/t/p/w185//"+result['poster_path'];

    for (var i = 0; i < result['genre_ids'].length; i++) {
      genre_ids.add(result['genre_ids'][i]);
    }

    backdrop_path = "http://image.tmdb.org/t/p/w185//"+result['backdrop_path'].toString();
    adult = result['adult'];
    overview = result['overview'].toString();
    release_date = result['release_date'].toString();
  }

  String get get_release_date => release_date;

  String get get_overview => overview;

  bool get get_adult => adult;

  String get get_backcrop_path => backdrop_path;

  List<int> get get_genre_ids => genre_ids;

  String get get_poster_path => poster_path;

  double get get_popularity => popularity;

  String get get_title => title;

  String get get_vote_average => vote_average;

  bool get get_video => video;

  String get get_vote_count => vote_count;

  int get get_id => id;

  @override
  // TODO: implement props
  List<Object> get props => [
        vote_count,
        id,
        video,
        vote_count,
        title,
        popularity,
        poster_path,
        genre_ids,
        backdrop_path,
        adult,
        overview,
        release_date
      ];
}
