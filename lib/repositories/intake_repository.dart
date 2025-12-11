import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/intake_record.dart';

class IntakeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  IntakeRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _intakeCollection {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('intake_records');
  }

  Future<List<IntakeRecord>> fetchIntakeRecords() async {
    try {
      final snapshot = await _intakeCollection
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => IntakeRecord.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch intake records: $e');
    }
  }

  Future<IntakeRecord> createIntakeRecord(IntakeRecord record) async {
    try {
      final docRef = await _intakeCollection.add(record.toFirestore());
      return record.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create intake record: $e');
    }
  }

  Future<void> updateIntakeRecord(IntakeRecord record) async {
    if (record.id == null) {
      throw Exception('Cannot update record without ID');
    }
    try {
      await _intakeCollection.doc(record.id).update(record.toFirestore());
    } catch (e) {
      throw Exception('Failed to update intake record: $e');
    }
  }

  Future<void> deleteIntakeRecord(String recordId) async {
    try {
      await _intakeCollection.doc(recordId).delete();
    } catch (e) {
      throw Exception('Failed to delete intake record: $e');
    }
  }

  Future<int> getTodayTotalIntake() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final snapshot = await _intakeCollection
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['amount'] as int?) ?? 0;
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get today\'s total: $e');
    }
  }
}
