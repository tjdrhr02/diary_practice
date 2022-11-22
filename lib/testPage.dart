import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final db = FirebaseFirestore.instance;
  Map<int, String> emotionMap = {0: "best", 1: "happy", 2: "sad", 3: "tired", 4: "annoying"};

  String randomEmotion(int i) {
    String emotion = "";

    if(i < 23){
      emotion = emotionMap[Random().nextInt(emotionMap.length)]!;
    }

    return emotion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: ElevatedButton(
          child: Text("g"),
          onPressed: () async {
            // for(int i = 1; i < 31; i++){
            //   Map<String, dynamic> data = <String, dynamic>{
            //     "month": 11.0,
            //     "day": i.toDouble(),
            //     "DOTW": (i%7).toDouble(),
            //     "emotion": randomEmotion(i),
            //   };
            //
            //   DocumentReference newDocIdRef = db.collection("diarys").doc();
            //
            //   newDocIdRef.set(data);
            // }

            // read all documents from collection
            final db = FirebaseFirestore.instance;
            List<String> emotions = [];

            QuerySnapshot querySnapshot = await db.collection("diarys").orderBy("day").get();
            List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

            if(allData.isNotEmpty) {
              for(int i = 0; i < allData.length; i++) {
                emotions.add(allData[i]["emotion"]);
              }
            }

            Navigator.of(context).pushNamed('/toStatisticsPage', arguments: emotions);


          },
        ),
      ),
    );
  }
}