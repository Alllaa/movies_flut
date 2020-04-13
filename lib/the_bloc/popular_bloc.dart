import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movieapp/resources/movie_api_provider.dart';
import './bloc.dart';

class AllPopularBloc extends Bloc<AllMoviesEvent, AllMoviesState> {
  final MovieRepository movieRepository;

  AllPopularBloc(this.movieRepository);
  @override
  AllMoviesState get initialState => InitialAllMoviesState();

  @override
  Stream<AllMoviesState> mapEventToState(AllMoviesEvent event) async* {
    yield AllMoviesLoading();
    if(event is GetAllPopular)
    {
      try{
        final itemModel = await movieRepository.fetchPopularList(false);
        final genreModel = await movieRepository.fetchGeneralList();
        yield AllPopularLoaded(itemModel,genreModel);
      }on NetworkError
      {
        yield MovieError("Couldn't fetch movies");
      }
    }
    // TODO: Add Logic
  }
}
