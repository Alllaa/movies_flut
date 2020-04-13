import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/models/genre_model.dart';
import 'package:movieapp/models/item_model.dart';
import 'package:movieapp/resources/movie_api_provider.dart';
import 'package:movieapp/screens/movie_details.dart';
import 'package:movieapp/the_bloc/bloc.dart';
import 'package:movieapp/the_bloc/popular_bloc.dart';

import '../app_custom.dart';
import '../colors_ui.dart';
import 'favourite_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllMoviesBloc>(
          create: (context) => AllMoviesBloc(MovieApiProvider()),
        ),
        BlocProvider<AllPopularBloc>(
          create: (context) => AllPopularBloc(MovieApiProvider()),
        ),
      ],
      child: ContentHome(),
    );
  }
}

class ContentHome extends StatefulWidget {
  @override
  _ContentHomeState createState() => _ContentHomeState();
}

class _ContentHomeState extends State<ContentHome> {
  @override
  void initState() {
    // TODO: implement initState
    final movieBloc = BlocProvider.of<AllMoviesBloc>(context);
    movieBloc.add(GetAllMovies());
    final lol = BlocProvider.of<AllPopularBloc>(context);
    lol.add(GetAllPopular());
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 20, top: 50),
                width: MediaQuery.of(context).size.width,
//                height: MediaQuery
//                    .of(context)
//                    .size
//                    .height,
                color: bgColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Search',
                          style: TextStyle(
                              fontFamily: 'SubstanceMedium',
                              fontSize: 30,
                              color: Colors.white),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () => Navigator.push(context, new MyCustomRoute(builder: (context) =>new FavouriteScreen())),
                            child: Icon(Icons.favorite,color: Colors.white,size: 30,),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextField(
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Movie,Actors,Directors...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: textColor,
                            fontSize: 24,
                          )),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    seeAll("Recent"),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width - 20,
                      height: 320,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: BlocListener<AllMoviesBloc, AllMoviesState>(
                        listener: (context, state) {
                          if (state is MovieError) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          }
                        },
                        child: BlocListener<AllMoviesBloc, AllMoviesState>(
                          listener:
                              (BuildContext context, AllMoviesState state) {
                            if (state is AllMoviesLoaded) print("hello");
                          },
                          child: BlocBuilder<AllMoviesBloc, AllMoviesState>(
                            builder: (context, state) {
                              if (state is InitialAllMoviesState) {
                                return buildInitial();
                              } else if (state is AllMoviesLoading) {
                                return buildLoading();
                              } else if (state is AllMoviesLoaded) {
                                return (loadeddata(context, state.itemModel,
                                    state.genreModel));
                              } else if (state is MovieError) {
                                return buildInitial();
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ),
                    seeAll("Popular"),
                    Container(
//                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width - 20,
                      height: 320,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: BlocListener<AllPopularBloc, AllMoviesState>(
                        listener: (context, state) {
                          if (state is MovieError) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          }
                        },
                        child: BlocBuilder<AllPopularBloc, AllMoviesState>(
                          builder: (context, state) {
                            if (state is InitialAllMoviesState) {
                              return buildInitial();
                            } else if (state is AllMoviesLoading) {
                              return buildLoading();
                            } else if (state is AllPopularLoaded) {
                              print("Hi All there 45456adsa54d65sa");
                              return (loadedPopulare(
                                  context, state.itemModel, state.generModel));
                            } else if (state is MovieError) {
                              return buildInitial();
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget buildInitial() {
    return Center();
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget loadeddata(
      BuildContext context, ItemModel itemModel, GenreModel genreModel) {
    int num = itemModel.results.length;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: num,
      itemBuilder: (context, index) {
        String genres = genreModel.getGenre(itemModel.results[index].genre_ids);
        return Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      result: itemModel.results[index],
                      genres: genres,
                    ),
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 350,
                  minWidth: MediaQuery.of(context).size.width * .4,
                  maxHeight: 350,
                  maxWidth: MediaQuery.of(context).size.width * .4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            itemModel.results[index].poster_path)),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      itemModel.results[index].title,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        );
      },
    );
  }

  Widget loadedPopulare(
      BuildContext context, ItemModel itemModel, GenreModel genreModel) {
    int num = itemModel.results.length;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: num,
      itemBuilder: (context, index) {
        String genres = genreModel.getGenre(itemModel.results[index].genre_ids);
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(
                          result: itemModel.results[index],
                          genres: genres,
                        ),
                      ),
                    );
                  },
                  child: Container(
//                  width: MediaQuSery.of(context).size.width / 2 - 10,
//                  height: 300,
//              color: Colors.red,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: CachedNetworkImageProvider(
                            itemModel.results[index].poster_path),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  height: 300,
//              color: Colors.yellow,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 30, left: 10, right: 10, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          itemModel.results[index].title,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          itemModel.results[index].release_date,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          genres,
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: iconColor,
                              size: 28,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: itemModel.results[index].vote_average,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '/10',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14))
                                  ]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            )
          ],
        );
      },
    );
  }

  Widget seeAll(String name) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 28, //                    color: Colors.redAccent,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Positioned(
            top: 3,
            right: 20,
            child: Text(
              'SEE ALL',
              style: TextStyle(
                color: textColor,
//                              fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}
