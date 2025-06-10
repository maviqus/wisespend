import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  static Future<void> getAllCategory() async {
    try {
      var res = await FirebaseFirestore.instance.collection('category').get();
      print(res);
    } catch (e) {
      print(e);
    }
  }
}
