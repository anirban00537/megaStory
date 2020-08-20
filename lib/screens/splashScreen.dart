import 'package:megaStory/screens/HomeScreen.dart';
import 'package:megaStory/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, AsyncSnapshot<FirebaseUser> snapShot) {
        if (snapShot.hasData) {
          if (snapShot.data != null) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
        //if user is not signed in
        return LoginScreen();
      },
    );
  }
}
