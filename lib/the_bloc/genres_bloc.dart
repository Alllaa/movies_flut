//import 'dart:async';
//import 'package:bloc/bloc.dart';
//import 'package:movieapp/models/item_model.dart';
//import 'package:movieapp/resources/movie_api_provider.dart';
//import './bloc.dart';
//
//class Genres extends Bloc<AllMoviesEvent, AllMoviesState> {
//  final MovieRepository movieRepository;
//
//  Genres(this.movieRepository);
//  @override
//  AllMoviesState get initialState => InitialAllMoviesState();
//
//  @override
//  Stream<AllMoviesState> mapEventToState(
//      AllMoviesEvent event,
//      ) async* {
//    yield AllMoviesLoading();
//    if(event is GetGenres)
//    {
//      try{
//        final genreModel = await movieRepository.fetchGeneralList();
//        yield GenresLoaded(genreModel);
//      }on NetworkError
//      {
//        yield MovieError("Couldn't fetch movies");
//      }
//    }
//    // TODO: Add Logic
//  }
//}
