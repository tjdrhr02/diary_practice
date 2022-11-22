import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NullPage extends StatefulWidget {
  const NullPage({Key? key}) : super(key: key);

  @override
  State<NullPage> createState() => _NullPageState();
}

class _NullPageState extends State<NullPage> {
  final db = FirebaseFirestore.instance;

    @override
  Widget build(BuildContext context) {
    return Container();
  }
}
