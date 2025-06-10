import 'package:flutter/material.dart';
import 'package:wise_spend_app/data/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  Future<void> init() async {
    await CategoryService.getAllCategory();
  }
}
