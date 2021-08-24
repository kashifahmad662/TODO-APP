import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ToDoListData {
  late final int? id;
  late final String title;
  late final String content;
  late final String colorData;
  late final int day;
  late final int month;
  late final int year;
  late final int hour;
  late final int minute;
  late final int reminder;
  late final int colorIndex;

  ToDoListData(
      {this.id,
      required this.title,
      required this.content,
      required this.colorData,
      required this.day,
      required this.month,
      required this.year,
      required this.hour,
      required this.minute,
      required this.reminder,
        required this.colorIndex

      });

  ToDoListData.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        content = res["content"],
        colorData = res["colorData"],
        day = res["day"],
        month = res["month"],
        year = res["year"],
        hour = res["hour"],
        minute = res["minute"],
        reminder = res["reminder"],
        colorIndex = res["colorIndex"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'colorData': colorData,
      'day': day,
      'month': month,
      'year': year,
      'hour': hour,
      'minute': minute,
      'reminder': reminder,
      'colorIndex': colorIndex
    };
  }
}
