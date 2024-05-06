import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApiRepository {
  Future<List> getDataList(uid) async {
    final data = await FirebaseFirestore.instance
        .collection("kategori")
        .where('uid', isEqualTo: uid)
        .get();
    List allData = data.docs.map((doc) => doc.data()).toList();
    return allData;
  }
}
