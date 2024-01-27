import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectionNotifier extends ChangeNotifier {
  static final List<String> _list = [
    'Studies',
    'Reading',
    'Technologies',
    'Travel',
    'Psychology',
    'Gaming',
    'TV/Movies',
    'Sports',
    'Languages',
    'Fashion',
    'Fitness',
    'Pets',
    'Food',
    'Climate Change',
    'Self-care',
    'Work life',
    'Culture',
    'Design',
    'Sociology',
    'Music',
    'Outdoor',
    'Networking',
    'Romance',
    'Shopping',
    'Sight-seeing',
  ];

  List<String> get list => _list;

  List<bool> isSelectedList = List.generate(_list.length, (index) => false);
  List<int> selectedIndices = [];

  void toggleChip(int index) {
    if (isSelectedList[index]) {
      isSelectedList[index] = false;
      selectedIndices.remove(index);
    } else {
      if (isSelectedList.where((isSelected) => isSelected).length < 6) {
        isSelectedList[index] = true;
        selectedIndices.add(index);
      } else {
        Fluttertoast.showToast(
          msg: 'You can only select six(6) interests',
        );
      }
    }
    notifyListeners();
  }
}
