import 'package:flutter/material.dart';
import '../dataTypes.dart';

class MyState extends ChangeNotifier {
  late LogSign type;
  String username = '';
  String email = '';
  String password = '';

  int page = 0;
  void incrementPage() {
    page++;
    notifyListeners();
  }

  void decrementPage() {
    page--;
    notifyListeners();
  }
}
