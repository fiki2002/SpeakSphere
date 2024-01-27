import 'package:flutter/material.dart';

class NavBarNotifier extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void onNavBarTapped(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Lesson _selectedLesson = Lesson.audio;
  Lesson get selectedLesson => _selectedLesson;
  void onTabTapped(Lesson value) {
    _selectedLesson = value;
    notifyListeners();
  }

  bool animationStart = false;
  void startAnimation() {
    animationStart = true;
    notifyListeners();
  }

  void resetAnimation() {
    animationStart = false;
    notifyListeners();
  }
}

enum Lesson { audio, video }
