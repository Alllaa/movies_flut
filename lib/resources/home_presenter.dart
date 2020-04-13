import 'package:movieapp/database_helper/DatabaseHelper.dart';
import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/models/favourite_trailer.dart';

abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {
  HomeContract _view;
  var db = new DatabaseHelper();

  HomePresenter(this._view);

  delete(int movie_id) {
    var db = new DatabaseHelper();
    db.deleteFavourite(movie_id);
    db.deleteFavouriteTrailer(movie_id);
    updateScreen();
  }

  Future<List<Favourite>> getFavourites() {
    return db.getFavourites();
  }
  Future<List<Trailer>> getFavouritesTrailer(int movie_id) {
    return db.getMoviesTrailer(movie_id);
  }

  Future<bool> isItRecord(int movie_id) {
    return db.isItRecord(movie_id);
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
