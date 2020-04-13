import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movieapp/models/item_model.dart';
import 'package:movieapp/resources/movie_api_provider.dart';
import './bloc.dart';

class AllMoviesBloc extends Bloc<AllMoviesEvent, AllMoviesState> {
  final MovieRepository movieRepository;

  AllMoviesBloc(this.movieRepository);
  @override
  AllMoviesState get initialState => InitialAllMoviesState();

  @override
  Stream<AllMoviesState> mapEventToState(AllMoviesEvent event,) async* {
    yield AllMoviesLoading();
    if(event is GetAllMovies)
      {
        try{
            final itemModel = await movieRepository.fetchMovieList(true);
            final genreModel = await movieRepository.fetchGeneralList();
            yield AllMoviesLoaded(itemModel,genreModel);
        }on NetworkError
        {
            yield MovieError("Couldn't fetch movies");
        }
      }
    // TODO: Add Logic
  }
}
