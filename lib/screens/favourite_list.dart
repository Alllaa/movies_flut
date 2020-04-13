import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/models/favourite.dart';
import 'package:movieapp/resources/home_presenter.dart';
import 'package:movieapp/screens/favourite_detail.dart';

import '../app_custom.dart';
import '../colors_ui.dart';

class Favouritelist extends StatefulWidget {
  List<Favourite> favourites;
  HomePresenter homePresenter;

  Favouritelist(this.favourites, this.homePresenter);

  @override
  _FavouritelistState createState() => _FavouritelistState();
}

class _FavouritelistState extends State<Favouritelist> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: widget.favourites == null ? 0 : widget.favourites.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: ()=>  Navigator.push(context, new MyCustomRoute(builder: (context) =>new FavouriteDeatil(widget.favourites[index]))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(widget.favourites[index].poster_path,width: 185,),
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
                            widget.favourites[index].name,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.favourites[index].release_date,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            widget.favourites[index].genres,
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
                                    text: widget.favourites[index].vote_average,
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
                  SizedBox(height: 4,)

                ],
              )
            ],
          ),
        );
      },
    );
  }
}
