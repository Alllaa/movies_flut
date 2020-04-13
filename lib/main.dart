import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movieapp/screens/appintro.dart';
import 'package:movieapp/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_custom.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      home: CheckPage(),
    );
  }
}

bool firstRun = false;
//
//_checkFirstRun() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  bool firstRun = (prefs.getBool('firstRun') ?? true);
//  await prefs.setBool('firstRun', firstRun);
//}

class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  Future checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     firstRun = (prefs.getBool("firstRun")?? true);
    if (!firstRun) {
      SplashScreen();
    } else {
      await prefs.setBool("firstRun", false);
      Navigator.push(context, new MyCustomRoute(builder: (context) =>new AppIntroScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return firstRun ? AppIntroScreen() : SplashScreen();
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toAnotherScreen();
  }

  Future<Timer> toAnotherScreen() async {
    return new Timer(Duration(seconds: 2), onDoneFinishTime);
  }

  onDoneFinishTime() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D28),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  alignment: FractionalOffset.topCenter,
                  image: AssetImage('assets/images/splash.jpg'))),
        ),
      ),
    );
  }
}

