import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    initData().then((value) {
      navigateToHomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Daily ',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold) ,),
              Text('Manager',style: TextStyle(fontSize: 20) ,),
            ],
          ),
        ),
      )
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 1));
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacementNamed(context, '/homeScreen');
  }
}
