import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

var selectedValue, selectedContent;
String storyImagedownloadUrl, storyContentDownloadUrl, storyName;

class UploadStoryScreen extends StatefulWidget {
  @override
  _UploadStoryScreenState createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  void pickImage() async {
    try {
      selectedValue = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void pick() async {
    try {
      selectedContent = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: selectedValue == null
                    ? AssetImage("images/profile.png")
                    : FileImage(selectedValue),
                radius: 60,
              ),
              Positioned(
                  left: 70,
                  top: 80,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 30, color: Colors.black),
                    onPressed: () {
                      pickImage();
                    },
                  )),
            ],
          ),
          Text(
            "Story profile Image",
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: selectedContent == null
                    ? AssetImage("images/profile.png")
                    : FileImage(selectedContent),
                radius: 60,
              ),
              Positioned(
                  left: 70,
                  top: 80,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 30, color: Colors.black),
                    onPressed: () {
                      pick();
                    },
                  )),
            ],
          ),
          Text("Story Content"),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (val) {
                storyName = val;
              },
              decoration: InputDecoration(hintText: "Story Name"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RawMaterialButton(
              onPressed: () async {
                if (selectedValue != null && selectedContent != null) {
                  final DateTime now = DateTime.now();
                  final int millSeconds = now.millisecondsSinceEpoch;
                  final String month = now.month.toString();
                  final String date = now.day.toString();
                  final String storageId = (millSeconds.toString());
                  final String today = ('$month-$date');
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child("storyImages")
                      .child(today)
                      .child(storageId);

                  await ref.putFile(selectedValue).whenComplete(() => {}).then(
                      (value) => value.ref
                          .getDownloadURL()
                          .then((value) => storyImagedownloadUrl = value));

                  Reference referenmce = FirebaseStorage.instance
                      .ref()
                      .child("storyImages")
                      .child(today)
                      .child(storageId);

                  await referenmce
                      .putFile(selectedValue)
                      .whenComplete(() => {})
                      .then((val) => val.ref
                          .getDownloadURL()
                          .then((val) => storyContentDownloadUrl = val));

                  DocumentReference reference = FirebaseFirestore.instance
                      .collection("Stories")
                      .doc(storyName);
                  reference.set({
                    "storyImageUrl": storyImagedownloadUrl.toString(),
                    "storyContentUrl": storyContentDownloadUrl.toString(),
                    "storyName": storyName.toString(),
                  });
                  // CollectionReference refe =
                  //     FirebaseFirestore.instance.collection("Stories");

                  // refe.add({
                  //   "date":DateTime.now().toString(),
                  //   "file":{
                  //     "0":{
                  //       "fileTitle":{
                  //         "en":storyName.toString()
                  //       },
                  //       "filetype":"image",
                  //       "url":{
                  //         "en":storyContentDownloadUrl.toString()
                  //       }
                  //     }
                  //   },
                  //   "previewImage":storyImagedownloadUrl.toString(),
                  //   "previewTitle":storyName.toString()

                  // });
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              fillColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "Upate Tutors",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
