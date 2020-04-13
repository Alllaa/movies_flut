import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AllMoviesEvent extends Equatable {

  const AllMoviesEvent();
}
class GetAllMovies extends AllMoviesEvent
{

  const GetAllMovies();
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class GetAllPopular extends AllMoviesEvent
{

  const GetAllPopular();
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class GetGenres extends AllMoviesEvent
{
  const GetGenres();
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class GetTrailer extends AllMoviesEvent{

  final int id;

  GetTrailer(this.id);
  @override
  // TODO: implement props
  List<Object> get props => [id];

}
