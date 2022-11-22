import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: ElevatedButton(
          child: Text("g"),
          onPressed: () async {
            // get all documents from collection
            QuerySnapshot querySnapshot = await db.collection("cities").get();
            final allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
            print(allData[0]["name"]);
            print(allData.length);
          },
        ),
      ),
    );
  }
}