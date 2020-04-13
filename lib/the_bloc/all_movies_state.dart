import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/models/genre_model.dart';
import 'package:movieapp/models/item_model.dart';
import 'package:movieapp/models/trailer_model.dart';

@immutable
abstract class AllMoviesState extends Equatable {
  const AllMoviesState();
}

class InitialAllMoviesState extends AllMoviesState {
  const InitialAllMoviesState();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AllMoviesLoading extends AllMoviesState {
  const AllMoviesLoading();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AllMoviesLoaded extends AllMoviesState {
  final ItemModel itemModel;
  final GenreModel genreModel;
  const AllMoviesLoaded(this.itemModel,this.genreModel);

  @override
  // TODO: implement props
  List<Object> get props => [itemModel];
}
class AllPopularLoaded extends AllMoviesState
{
  final ItemModel itemModel;
  final GenreModel generModel;

  AllPopularLoaded(this.itemModel,this.generModel);

  @override
  // TODO: implement props
  List<Object> get props => [itemModel];

}

class GenresLoaded extends AllMoviesState
{
  final GenreModel genreModel;

    GenresLoaded(this.genreModel);

  @override
  // TODO: implement props
  List<Object> get props => [genreModel];

}
class TrailerLoaded extends AllMoviesState{
  final TrailerModel trailerModel;

    TrailerLoaded(this.trailerModel);
  @override
  // TODO: implement props
  List<Object> get props => [trailerModel];

}

class MovieError extends AllMoviesState {
  final String message;

  const MovieError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
