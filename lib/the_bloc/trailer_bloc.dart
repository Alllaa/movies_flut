import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/resources/movie_api_provider.dart';
import 'package:movieapp/the_bloc/bloc.dart';

class TrailerBloc extends Bloc<AllMoviesEvent,AllMoviesState>{
  final MovieRepository movieRepository;

  TrailerBloc(this.movieRepository);
  @override
  // TODO: implement initialState
  AllMoviesState get initialState => InitialAllMoviesState();

  @override
  Stream<AllMoviesState> mapEventToState(AllMoviesEvent event) async*{
    yield AllMoviesLoading();
    if (event is GetTrailer)
      {
        try{
          final trailerModel =  await movieRepository.fetchTrailerList(event.id);
          yield TrailerLoaded(trailerModel);
        } on NetworkError{
          yield MovieError("Couldn't fetch movies");
        }
      }
  }

}