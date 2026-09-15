import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demix/features/business/domain/entities/business.dart';
import 'package:equatable/equatable.dart';

class BusinessPage extends Equatable {
  const BusinessPage({
    required this.businesses,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<Business> businesses;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;

  @override
  List<Object?> get props => [businesses, lastDocument, hasMore];
}
