import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";

  String photoUrl = "";
  String email = "";
  bool isLoaded = true;

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    try {
      FirebaseUser user = await _auth.currentUser();

      DocumentSnapshot doc =
          await _db.collection("users").document(user.uid).get();

      setState(() {
        isLoaded = true;
        name = doc.data["displayName"];
        photoUrl = doc.data["photoUrl"];
        email = doc.data["emailUser"];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(170),
                  child: Image(
                    image: NetworkImage(photoUrl),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text("Logout"),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text("Loading"),
        ),
      );
    }
  }
}
