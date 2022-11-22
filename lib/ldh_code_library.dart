import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

//// write one
// Map<String, dynamic> data = <String, dynamic>{};
//
// DocumentReference newDocIdRef = db.collection("colName").doc();
//
// newDocIdRef.set(data);


//// read all documents from collection
// QuerySnapshot querySnapshot = await db.collection("colName").get();
// List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//
// if(allData.isNotEmpty){
//  print(allData[0]["fieldName"]);
//  print(allData.length);
// }

//// read one doc
// DocumentSnapshot<Map<String, dynamic>> docIdSnapshot = await db.collection("colName").doc("docId").get();
//
// if (docIdSnapshot.exists) {
//  print(docIdSnapshot.data()!["fieldName"]);
// }


//// update one doc
// decIdRef.id == docId
// DocumentReference docIdRef = db.collection("colName").doc("docId");
// docIdRef.update( {"fieldName": value, "fieldName2": value2} );


//// delete one doc
// DocumentReference docIdRef = db.collection("colName").doc("docId");
// docIdRef.update( {"fieldName": FieldValue.delete()} );
