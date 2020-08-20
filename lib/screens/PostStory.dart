import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PostStoryScreen extends StatefulWidget {
  @override
  _PostStoryScreenState createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  File _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      try {
        _image = File(pickedFile.path);
      } catch (e) {
        print(e);
      }
    });
  }

  bool _isUploading = false;
  bool _isUploadComplete = false;
  double _uploadProgress = 0;
  //firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //firebase

  _uploadImage() async {
    try {
      if (_image != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        FirebaseUser user = await _auth.currentUser();
        String filename = basename(
            DateTime.now().microsecondsSinceEpoch.toString() + _image.path);
        final StorageReference storageReference =
            _storage.ref().child("posts").child(user.uid).child(filename);

        final StorageUploadTask uploadTask = storageReference.putFile(_image);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          var totalBytes = event.snapshot.totalByteCount;
          var transfered = event.snapshot.bytesTransferred;
          double progress = ((transfered * 100) / totalBytes) / 100;
          setState(() {
            _uploadProgress = progress;
          });
        });

        StorageTaskSnapshot onComplete = await uploadTask.onComplete;
        String photoUrl = await onComplete.ref.getDownloadURL();
        _db.collection("posts").add({
          "photoUrl": photoUrl,
          "name": user.displayName,
          "title": _titleController.text,
          "story": _storyController.text,
          "date": DateTime.now(),
          "uploadedBy": user.uid
        });
        //when code complete
        setState(() {
          _isUploading = false;
          _isUploadComplete = true;
        });
        streamSubscription.cancel();
        Navigator.pop(this.context);
      } else {
        showDialog(
            context: this.context,
            builder: (ctx) {
              return AlertDialog(
                  content: Text("Please select the image"),
                  title: Text("Alert"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)));
            });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getImageFromGalarry() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      try {
        _image = File(pickedFile.path);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Story'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: Color(0xff5f27cd),
            ),
            onPressed: getImage,
          ),
          IconButton(
            icon: Icon(
              Icons.storage,
              color: Color(0xff5f27cd),
            ),
            onPressed: getImageFromGalarry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _image == null
                  ? Image.asset(
                      "assets/images/default.png",
                      height: 150,
                    )
                  : Image.file(_image),
            ),
            _isUploading
                ? LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.grey,
                  )
                : Container(),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title of the story",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _storyController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write your story",
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text(
                "Publish",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Color(0xff5f27cd),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
