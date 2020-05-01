import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/colors_ui.dart';

import '../app_custom.dart';
import 'home.dart';

class AppIntroScreen extends StatefulWidget {
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

const titles = ["Offline Database", "Millions Of Movies", "Pre-Notification"];
const descriptions = [
  "create your own favorite list and browse your list without internet",
  "Get millions of movies instantly",
  "movies on your favorite list, let you know before the vision date"
];

const images = [
  "assets/images/data.png",
  "assets/images/movies.png",
  "assets/images/notification.png"
];

class _AppIntroScreenState extends State<AppIntroScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 10,
      width: isActive ? 20.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? bgColor : Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      pagenation(titles[0], descriptions[0], images[0], 0),
                      pagenation(titles[1], descriptions[1], images[1], 1),
                      pagenation(titles[2], descriptions[2], images[2], 2)
                    ],
                  ),
                ),
                _currentPage == 2
                    ? InkWell(
                        onTap: () => Navigator.push(
                            context,
                            new MyCustomRoute(
                                builder: (context) => new Home())),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: iconColor),
                          margin: EdgeInsets.symmetric(horizontal: 80),
                          height: 60,
                          child: Center(
                            child: Text(
                              "GET STARTED!",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: "SubstanceMedium"),
                            ),
                          ),
                        ))
                    : SizedBox(
                        height: 30,
                      ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
            Positioned(
              top: 50,
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
//                  color: Colors.red,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 20,
                        top: 1,
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              new MyCustomRoute(
                                  builder: (context) => new Home())),
                          child: Text(
                            "SKIP",
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget pagenation(String title, String description, String image, int index) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              height: 250,
              child: Center(
                child: Image.asset(
                  image,
                  width: 120,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150), color: bgColor),
            ),
            SizedBox(
              height: 30,
            ),
            Text("$title",
                style: TextStyle(
                    fontSize: 30,
                    color: textColor,
                    fontFamily: "SubstanceMedium"),
                textAlign: TextAlign.center),
            SizedBox(
              height: 20,
            ),
            Text(
              "$description",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
//                fontFamily: "SubstanceMedium"
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
