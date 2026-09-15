import 'package:equatable/equatable.dart';

class WorkingHours extends Equatable {
  const WorkingHours({required this.open, required this.close});

  /// Format: HH:mm
  /// Example: 10:00
  final String open;

  /// Format: HH:mm
  /// Example: 23:00
  final String close;

  @override
  List<Object?> get props => [open, close];
}
