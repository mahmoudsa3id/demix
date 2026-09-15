import 'package:flutter/material.dart';

bool isBusinessCurrentlyOpen({
  required String? open,
  required String? close,
  required bool isManuallyOpen,
  DateTime? now,
}) {
  if (!isManuallyOpen) return false;

  if (open == null || close == null) {
    return false;
  }

  final openMinutes = _parseMinutes(open);
  final closeMinutes = _parseMinutes(close);

  if (openMinutes == null || closeMinutes == null) {
    return false;
  }

  final current = now ?? DateTime.now();
  final currentMinutes = current.hour * 60 + current.minute;

  if (openMinutes == closeMinutes) {
    return true;
  }

  if (openMinutes < closeMinutes) {
    return currentMinutes >= openMinutes && currentMinutes < closeMinutes;
  }

  return currentMinutes >= openMinutes || currentMinutes < closeMinutes;
}

String formatBusinessTime(String value, BuildContext context) {
  final parts = value.split(':');

  if (parts.length != 2) {
    return value;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null || minute == null) {
    return value;
  }

  final time = TimeOfDay(hour: hour, minute: minute);

  return time.format(context);
}

int? _parseMinutes(String value) {
  final parts = value.split(':');

  if (parts.length != 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59) {
    return null;
  }

  return hour * 60 + minute;
}
