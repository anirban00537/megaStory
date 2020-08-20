import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Firestore _db = Firestore.instance;
  bool _isLoading = true;
  List<DocumentSnapshot> posts;

  @override
  void initState() {
    _fetchPost();
    super.initState();
  }

  _fetchPost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot snapshot = await _db
          .collection("posts")
          .orderBy("date", descending: true)
          .getDocuments();
      setState(() {
        _isLoading = false;
        posts = snapshot.documents;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        child: LinearProgressIndicator(),
      );
    } else {
      return Container(
        child: RefreshIndicator(
          onRefresh: () {
            _fetchPost();
            return null;
          },
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, i) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Color(0x33000000),
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(posts[i].data["name"]),
                        //Text(posts[i].data["date"].toString()),
                      ],
                    ),
                    Center(
                      child: FadeInImage(
                        placeholder: AssetImage("assets/images/default.png"),
                        image: NetworkImage(
                          posts[i].data["photoUrl"],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        posts[i].data["title"],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        posts[i].data["story"],
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
