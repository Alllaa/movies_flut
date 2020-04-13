import 'dart:typed_data';

import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/models/favourite_trailer.dart';
import 'package:movieapp/resources/home_presenter.dart';
import 'package:movieapp/screens/movie_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors_ui.dart';

class FavouriteDeatil extends StatefulWidget {
  Favourite favourite;

  FavouriteDeatil(this.favourite);

  @override
  _FavouriteDeatilState createState() => _FavouriteDeatilState();
}

class _FavouriteDeatilState extends State<FavouriteDeatil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(widget.favourite),
    );
  }
}

Uint8List backdrop_path2;

class HomeScreen extends StatefulWidget {
  Favourite favourite;

  HomeScreen(this.favourite);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeContract {
  HomePresenter homePresenter;
  bool isItRecord = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePresenter = HomePresenter(this);
    backdrop_path2 = widget.favourite.poster_path;
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width) / 2;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
                    image: MemoryImage(widget.favourite.poster_path))),
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
          FutureBuilder<bool>(
            future: homePresenter.isItRecord(widget.favourite.movie_id),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              var data = snapshot.data;
              if (isItRecord != true) isItRecord = data;
              print("gridi");
              return isItRecord == false
                  ? Positioned(
                      right: 20,
                      top: 50,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            insertFavourite(context, homePresenter,
                                widget.favourite, widget.favourite.genres);
                            isItRecord = true;
                            AchievementView(context,
                                title: "Information!",
                                subTitle: "The movie added to favourites",
                                icon: Icon(
                                  Icons.movie,
                                  color: Colors.white,
                                ),
                                color: textColor,
                                textStyleTitle:
                                    TextStyle(fontFamily: "SubstanceMedium"),
                                duration: Duration(seconds: 1),
                                isCircle: true, listener: (status) {
                              print(status);
                            })
                              ..show();
                          });
                        },
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Positioned(
                      right: 20,
                      top: 50,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            homePresenter.delete(widget.favourite.movie_id);
                            isItRecord = false;
                            AchievementView(context,
                                title: "Information!",
                                subTitle: "The movie removed from favourites",
                                icon: Icon(
                                  Icons.movie,
                                  color: Colors.white,
                                ),
                                color: textColor,
                                textStyleTitle:
                                    TextStyle(fontFamily: "SubstanceMedium"),
                                duration: Duration(seconds: 1),
                                isCircle: true, listener: (status) {
                              print(status);
                            })
                              ..show();
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    );
            },
          ),
          Positioned(
            top: 320,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 8),
              width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.favourite.name,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned(
              left: 20, top: 310, child: GenresItems(widget.favourite.genres)),
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
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.favourite.popularity.toString(),
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
                        width: (MediaQuery.of(context).size.width - 40) / 3,
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
                                    text: widget.favourite.vote_average,
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
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.favourite.vote_count.toString(),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 530,
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
                      widget.favourite.description,
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
                    FutureBuilder<List<Trailer>>(
                      future: homePresenter
                          .getFavouritesTrailer(widget.favourite.movie_id),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Container();
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                            var data = snapshot.data;
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 500,
                              child: GridView.count(
                                crossAxisCount: 2,
                                padding: EdgeInsets.all(0),
                                childAspectRatio: itemWidth / 165,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                physics: NeverScrollableScrollPhysics(),
                                children: new List<Widget>.generate(data.length,
                                    (index) {
                                  return new GridTile(
                                      child: InkWell(
                                    onTap: () => _launchURL(
                                        "https://www.youtube.com/watch?v=" +
                                            data[index].link),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: InkWell(
                                        onTap: () => _launchURL(
                                            "https://www.youtube.com/watch?v=" +
                                                data[index].link),
                                        child: Wrap(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    width: itemWidth,
                                                    height: 100,
                                                    color: Colors.black38,
                                                  ),
                                                  Positioned(
                                                    top: 36,
                                                    left:
                                                        (itemWidth - 36 - 16) /
                                                            2,
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
                                              data[index].title,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                                }),
                              ),
                            );
                        }
                      },
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

  @override
  void screenUpdate() {
    // TODO: implement screenUpdate
  }
}

Future insertFavourite(BuildContext context, HomePresenter homePresenter,
    Favourite data, String genres) async {
  Client client = new Client();
  Uint8List _image = await client.readBytes(data.poster_path);
  Favourite favourite = new Favourite(
      data.name,
      data.id,
      _image,
      data.release_date,
      data.vote_count,
      data.vote_average,
      genres,
      data.description,
      data.popularity.toString());
  await homePresenter.db.insertMovie(favourite);
  homePresenter.updateScreen();
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else
    throw "Could not launch $url";
}
