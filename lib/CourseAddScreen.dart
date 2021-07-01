import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

var selectedfile;

class CourseAddScreen extends StatefulWidget {
  const CourseAddScreen({Key key}) : super(key: key);

  @override
  _CourseAddScreenState createState() => _CourseAddScreenState();
}

class _CourseAddScreenState extends State<CourseAddScreen> {
  String courseName;
  double courseFee;
  double rating;
  String tutordescription;
  String tutorExperience;
  String tutorName;
  final storePath = FirebaseFirestore.instance;
  String downloadUrl;
  String tutorMailId;
  double tutorCourseFee;
  String Batchnum;
  double noofRegistrationCount;
  double noofDaysofCourse;

  void pickImage() async {
    try {
      selectedfile = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void uploadDataStorage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  courseName = val;
                },
                decoration: InputDecoration(hintText: "Course Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (value) {
                  tutorExperience = value;
                },
                decoration: InputDecoration(hintText: "Tutor Student Count"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (value) {
                  rating = double.parse(value);
                },
                decoration: InputDecoration(hintText: "Tutor Rating"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (value) {
                  tutorMailId = value;
                },
                decoration: InputDecoration(hintText: "Tutor Email ID"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  tutorName = val;
                },
                decoration: InputDecoration(hintText: "Tutor Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  tutordescription = val;
                },
                decoration: InputDecoration(hintText: "Tutor Description"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  tutorCourseFee = double.parse(val);
                },
                decoration: InputDecoration(hintText: "Tutor Course Fee"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  Batchnum = val;
                },
                decoration: InputDecoration(hintText: "Batch Number"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  noofRegistrationCount = double.parse(val);
                },
                decoration: InputDecoration(hintText: "Registrations Limit"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  noofRegistrationCount = double.parse(val);
                },
                decoration: InputDecoration(hintText: "No of Registration Count"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  noofDaysofCourse = double.parse(val);
                },
                decoration: InputDecoration(hintText: "No of Days of Course"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                onChanged: (val) {
                  courseFee = double.parse(val);
                },
                decoration: InputDecoration(hintText: "Course Fee"),
              ),
            ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: selectedfile == null
                      ? AssetImage("images/profile.png")
                      : FileImage(selectedfile),
                  radius: 60,
                ),
                Positioned(
                    left: 70,
                    top: 80,
                    child: IconButton(
                      icon:
                          Icon(Icons.camera_alt, size: 30, color: Colors.black),
                      onPressed: () {
                        pickImage();
                      },
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RawMaterialButton(
              onPressed: () async {
                uploadDataStorage();
                if (selectedfile != null) {
                  final DateTime now = DateTime.now();
                  final int millSeconds = now.millisecondsSinceEpoch;
                  final String month = now.month.toString();
                  final String date = now.day.toString();
                  final String storageId = (millSeconds.toString());
                  final String today = ('$month-$date');
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child("tutorImages")
                      .child(today)
                      .child(storageId);

                  await ref.putFile(selectedfile).whenComplete(() => {}).then(
                      (value) => value.ref
                          .getDownloadURL()
                          .then((value) => downloadUrl = value));
                }

                if (courseName != null &&
                    tutorName != null &&
                    tutorExperience != null &&
                    tutordescription != null &&
                    rating != null &&
                    downloadUrl != null &&
                    Batchnum != null) {
                  CollectionReference ref = storePath.collection("Tutors");
                  ref.add({
                    "courseName": courseName.toString(),
                    "tutorName": tutorName.toString(),
                    "batchNumber": Batchnum.toString(),
                    "courseFee":courseFee,
                    "registrationsLimit":noofRegistrationCount,
                    "noOfDaysofCurse":noofDaysofCourse,
                    "tutorExperience": tutorExperience.toString(),
                    "rating": rating.toString(),
                    "tutorDescription": tutordescription.toString(),
                    "tutorImageUrl": downloadUrl.toString()
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Upload",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
