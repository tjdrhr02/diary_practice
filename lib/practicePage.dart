import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {


  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    db.collection('diarys').get().then((QuerySnapshot querySnapshot) {
      List<String> emotions = [];
      querySnapshot.docs.forEach((doc) {
        emotions.add(doc["emotion"]);
      });

      print(emotions);
    });


    return Container();
  }
}
