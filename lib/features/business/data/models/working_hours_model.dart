import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/working_hours.dart';

class WorkingHoursModel extends WorkingHours {
  const WorkingHoursModel({required super.open, required super.close});

  factory WorkingHoursModel.fromMap(Map<String, dynamic> map) {
    return WorkingHoursModel(
      open: map['open']?.toString() ?? '10:00',
      close: map['close']?.toString() ?? '23:00',
    );
  }

  factory WorkingHoursModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return WorkingHoursModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {'open': open, 'close': close};
  }
}
