import 'package:flutter/material.dart';
import 'package:movieapp/colors_ui.dart';
import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/resources/home_presenter.dart';

import 'favourite_list.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    implements HomeContract {
  HomePresenter homePresenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePresenter = new HomePresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<Favourite>>(
              future: homePresenter.getFavourites(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snapshot.hasError) print(snapshot.error);
                    var data = snapshot.data;
                    return Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: snapshot.hasData
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      height: 60,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: 14,
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Favourites",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "SubstanceMedium",
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: MediaQuery.of(context).size.height -
                                        110,
                                    child: Favouritelist(data, homePresenter),
                                  )
                                ],
                              )
                            : rebuildAllChildren(context));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void screenUpdate() {
    // TODO: implement screenUpdate
    setState(() {});
  }
}
 rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }
  (context as Element).visitChildren(rebuild);
}
