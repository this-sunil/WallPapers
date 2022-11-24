import 'package:flutter/material.dart';

class NotificationCounters extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  NotificationCounters(this._counter):super();


  void increment() {

    _counter++;
    notifyListeners();
  }
  decrement(){
    _counter=0;
    notifyListeners();
  }
}