import 'package:cloud_firestore/cloud_firestore.dart';

class IntakeRecord {
  final String? id;
  final String time;
  final int amount;
  final String type;
  final DateTime createdAt;

  IntakeRecord({
    this.id,
    required this.time,
    required this.amount,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory IntakeRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IntakeRecord(
      id: doc.id,
      time: data['time'] ?? '',
      amount: data['amount'] ?? 0,
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'time': time,
      'amount': amount,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  IntakeRecord copyWith({
    String? id,
    String? time,
    int? amount,
    String? type,
    DateTime? createdAt,
  }) {
    return IntakeRecord(
      id: id ?? this.id,
      time: time ?? this.time,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedAmount => '$amount ml';
}
