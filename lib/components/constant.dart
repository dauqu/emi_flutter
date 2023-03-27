import 'package:flutter/material.dart';

String api = "http://localhost:4000/api";
// String api = "https://emi-backend-tnqe7m.dauqu.host/api";

// prinary color
Color primaryColor = const Color(0xFF448AFF);
Color primaryMid = const Color.fromARGB(255, 159, 180, 255);
Color primaryAccent = const Color.fromARGB(255, 217, 228, 253);

// primary gray
Color primaryGray = const Color.fromARGB(255, 192, 202, 233);

// secondary color
Color secondaryColor = Colors.grey.shade700;
Color secondaryAccent = Colors.grey.shade400;

// unordered list
String bullet = "\u2022";

Color getColor(String type) {
  switch (type) {
    case "success":
      return Colors.green;
    case "error":
      return Colors.red;
    case "warning":
      return Colors.yellow.shade800;
    case "info":
      return Colors.blue;
    default:
      return Colors.green;
  }
}

ScaffoldFeatureController mySnackBar(
  BuildContext context,
  String message, {
  String type = "success",
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: getColor(type),
      duration: const Duration(seconds: 2),
    ),
  );
}

// iso string date to normal date
String toDateTime(
  String date, {
  bool withtime = false,
  bool withampm = false,
  String separator = "-",
}) {
  DateTime dateTime = DateTime.parse(date);
  String day = dateTime.day < 10 ? "0" : "";
  day += dateTime.day.toString();

  String month = dateTime.month < 10 ? "0" : "";
  month += dateTime.month.toString();

  String hour = dateTime.hour < 10 ? "0" : "";
  hour += dateTime.hour.toString();

  String minute = dateTime.minute < 10 ? "0" : "";
  minute += dateTime.minute.toString();

  String ampm = "AM";
  if (dateTime.hour > 12) {
    hour = (dateTime.hour - 12).toString();
    ampm = "PM";
  }

  String formattedDate = "$day$separator$month$separator${dateTime.year}";
  if (withtime) {
    formattedDate += " $hour:$minute";
  }
  if (withampm) {
    formattedDate += " $ampm";
  }
  return formattedDate;
}
