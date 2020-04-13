import 'dart:convert';
import 'dart:typed_data';

import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movieapp/colors_ui.dart';
import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/models/favourite_trailer.dart';
import 'package:movieapp/models/item_model.dart';
import 'package:movieapp/models/trailer_model.dart';
import 'package:movieapp/resources/home_presenter.dart';
import 'package:movieapp/resources/movie_api_provider.dart';
import 'package:movieapp/the_bloc/bloc.dart';
import 'package:movieapp/the_bloc/trailer_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetails extends StatefulWidget {
  final Result result;
  final String genres;

  const MovieDetails({this.result, this.genres});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}
FavouriteTrailer temp;
IconData myicon;
String backdrop_path = "";

class _MovieDetailsState extends State<MovieDetails> implements HomeContract {
  HomePresenter homePresenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePresenter = new HomePresenter(this);
    myicon = Icons.favorite_border;
    backdrop_path = widget.result.backdrop_path;
  }

  @override
  Widget build(BuildContext context) {
//     new Future.delayed(Duration(seconds: 1));
    return BlocProvider(
      create: (context) => TrailerBloc(MovieApiProvider()),
      child: Scaffold(
        body: ContentPage(
            result: widget.result,
            genres: widget.genres,
            homePresenter: homePresenter
        ),
      ),
    );
  }

  @override
  void screenUpdate() {
    // TODO: implement screenUpdate
  }
}

class ContentPage extends StatefulWidget {
  final String genres;
  final Result result;
  final HomePresenter homePresenter;

  const ContentPage({this.genres, this.result, this.homePresenter});

  @override
  _ContentPageState createState() => _ContentPageState();
}

const Base64Codec base64 = Base64Codec();

class _ContentPageState extends State<ContentPage> {
  bool isItRecord = false;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      color: bgColor,
      child: Stack(
        children: <Widget>[
          Container(
            height: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  alignment: FractionalOffset.topCenter,
//                    image: NetworkImage(widget.result.poster_path.replaceAll("w185", "w400"))
                  image: NetworkImage(
                    widget.result.poster_path.replaceAll("w185", "w400"),
                  ),
                )),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // futureBuilder
          FutureBuilder<bool>(
            future: widget.homePresenter.isItRecord(widget.result.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              var data = snapshot.data;
              if (isItRecord != true) isItRecord = data;
              print("gridi");
              return isItRecord == false
                  ?
              Positioned(
                right: 20,
                top: 50,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      insertFavourite(context, widget.homePresenter, widget
                          .result, widget.genres,temp);
                      isItRecord = true;
                      AchievementView(context,
                          title: "Information!",
                          subTitle: "The movie added to favourites",
                          icon: Icon(Icons.movie, color: Colors.white,),
                      color: textColor,
                      textStyleTitle: TextStyle(
                        fontFamily: "SubstanceMedium"
                      ),
                      duration: Duration(seconds: 1),
                      isCircle: true,
                      listener: (status)
                      {
                        print(status);
                      })..show();
                    });
                  },
                  child: Icon(Icons.favorite_border,color: Colors.white,),
                ),
              ):
              Positioned(
                right: 20,
                top: 50,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.homePresenter.delete(widget.result.id);
                      isItRecord = false;
                      AchievementView(context,
                          title: "Information!",
                          subTitle: "The movie removed from favourites",
                          icon: Icon(Icons.movie, color: Colors.white,),
                          color: textColor,
                          textStyleTitle: TextStyle(
                              fontFamily: "SubstanceMedium"
                          ),
                          duration: Duration(seconds: 1),
                          isCircle: true,
                          listener: (status)
                          {
                            print(status);
                          })..show();
                    });
                  },
                  child: Icon(Icons.favorite,color: Colors.white,),
                ),
              );
            },
          ),
          Positioned(
            top: 320,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 8),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 80,
              decoration: BoxDecoration(
                  gradient: LinearGradient(stops: [
                    0.1,
                    0.3,
                    0.5,
                    0.7,
                    0.9
                  ], colors: [
                    bgColor.withOpacity(0.01),
                    bgColor.withOpacity(0.25),
                    bgColor.withOpacity(0.6),
                    bgColor.withOpacity(0.9),
                    bgColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
          ),
          Positioned(
            left: 20,
            top: 260,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Text(
                widget.result.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned(left: 20, top: 310, child: GenresItems(widget.genres)),
          Positioned(
            left: 20,
            right: 20,
            top: 400,
            child: Container(
              height: 0.5,
              color: textColor,
            ),
          ),
          Positioned(
            top: 400,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              height: 120,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.result.popularity.toString(),
                                style: TextStyle(
                                    color: popularityColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              Text(
                                "Popularity",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: iconColor,
                                size: 28,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: widget.result.vote_average,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '/10',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14))
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery
                            .of(context)
                            .size
                            .width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.result.vote_count.toString(),
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              Text(
                                "Vote Count",
                                style: TextStyle(
                                  color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 18
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 520,
            child: Container(
              height: 0.5,
              color: textColor,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 530,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 530,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Description',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.result.overview,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Trailers',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      child: PreloadContent(
                          widget.result.id, widget.result.backdrop_path),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GenresItems extends StatefulWidget {
  String genres;

  GenresItems(this.genres);

  @override
  _GenresItemState createState() => _GenresItemState();
}

class _GenresItemState extends State<GenresItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getGenres(widget.genres),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasError)
              return Text('Error :${snapshot.error}');
            else
              return getGenres(snapshot);
        }
      },
    );
  }

  Widget genresItem(String genre) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Text(
          genre,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<List<Widget>> _getGenres(String genre) async {
    var values = new List<Widget>();
    var items = genre.split(',');
    for (int i = 0; i < items.length - 1; i++) {
      values.add(genresItem(items[i]));
      if (i != items.length - 1) {
        values.add(SizedBox(
          width: 10,
        ));
      }
    }
//    await new Future.delayed(Duration(seconds: 1));
    return values;
  }

  Widget getGenres(AsyncSnapshot snapshot) {
    List<Widget> values = snapshot.data;
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 40,
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 12,
        spacing: 8,
        children: values,
      ),
    );
  }
}

class PreloadContent extends StatefulWidget {
  int movieId;
  String backdrop_path;

  PreloadContent(this.movieId, this.backdrop_path);

  @override
  _PreloadContentState createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  @override
  void initState() {
    final trailerBloc = BlocProvider.of<TrailerBloc>(context);
    trailerBloc.add(GetTrailer(widget.movieId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrailerBloc, AllMoviesState>(builder: (context, state) {
      if (state is InitialAllMoviesState) {
        return Center(
          child: Text("NO DATA"),
        );
      } else if (state is AllMoviesLoading) {
        print("ALAASAYED" + state.toString());
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is TrailerLoaded) {
        print("ALAA_SAYED" + state.trailerModel.toString());
        if (state.trailerModel.results.length == 0) {
          return Container(
            child: Text(
              "No Trailer Found!",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          int itemrowCount = (state.trailerModel.results.length / 2).round();
          double _height = itemrowCount * 160.0;
          return Container(
              height: _height,
              child: TrailerPage(
                  state.trailerModel.results, widget.backdrop_path));
        }
      } else if (state is MovieError) {
        return Center(child: Text("NO Error"));
      }
      return Container();
    });
  }
}
class TrailerPage extends StatefulWidget {
  List<TResult> results;
  String backdrop_path;

  TrailerPage(this.results, this.backdrop_path);

  @override
  _TrailerPageState createState() => _TrailerPageState();
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else
    throw "Could not launch $url";
}

class _TrailerPageState extends State<TrailerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      temp = FavouriteTrailer.fromJson(widget.results);
  }
  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery
        .of(context)
        .size
        .width) / 2;

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(0),
      childAspectRatio: (itemWidth) / 165,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      children: List<Widget>.generate(widget.results.length, (index) {
        return GridTile(
          child: InkWell(
              onTap: () =>
                  _launchURL("https://www.youtube.com/watch?v=" +
                      widget.results[index].key),
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: InkWell(
                  onTap: () =>
                      _launchURL("https://www.youtube.com/watch?v=" +
                          widget.results[index].key),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Stack(
                          children: <Widget>[
                            Image.network(widget.backdrop_path),
                            Container(
                              width: itemWidth,
                              height: 100,
                              color: Colors.black38,
                            ),
                            Positioned(
                              top: 36,
                              left: (itemWidth - 36 - 16) / 2,
                              child: Icon(
                                Icons.play_circle_filled,
                                size: 36,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        widget.results[index].name,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              )),
        );
      }),
    );
  }
}

Future insertFavourite(BuildContext context, HomePresenter homePresenter,
    Result data, String genres,FavouriteTrailer myTrailers) async {
  Client client = new Client();
  Uint8List _image = await client.readBytes(
      data.poster_path);
  Favourite favourite = new Favourite(
      data.title,
      data.id,
      _image,
      data.release_date,
      data.vote_count,
      data.vote_average,
      genres,
      data.overview,
      data.popularity.toString()
  );
  await homePresenter.db.insertMovie(favourite);
//  FavouriteTrailer myTrailers = trailerData;
  for(var i = 0; i<myTrailers.results.length;i++)
    {
      myTrailers.results[i].movie_id = data.id;
      await homePresenter.db.insertMovieTrailer(myTrailers.results[i]);
    }
  homePresenter.updateScreen();
}