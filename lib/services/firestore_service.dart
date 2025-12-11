import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for managing user data in Firebase Firestore
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get the current user's ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Save user profile data during registration
  Future<void> saveUserData({
    required double weight,
    required String activityLevel,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    final dailyGoal = _calculateDailyGoal(weight, activityLevel);

    await _db.collection('user_body').doc(user.uid).set({
      'weight': weight,
      'activityLevel': activityLevel,
      'dailyGoal': dailyGoal,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserData() async {
    if (_userId == null) return null;
    
    final doc = await _db.collection('user_body').doc(_userId).get();
    return doc.data();
  }

  /// Update user profile data
  Future<void> updateUserData({
    double? weight,
    String? activityLevel,
  }) async {
    if (_userId == null) {
      throw Exception("No user is currently signed in.");
    }

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (weight != null) {
      updates['weight'] = weight;
    }
    if (activityLevel != null) {
      updates['activityLevel'] = activityLevel;
    }

    // Recalculate daily goal if weight or activity level changed
    if (weight != null || activityLevel != null) {
      final currentData = await getUserData();
      final newWeight = weight ?? currentData?['weight'] ?? 70.0;
      final newActivity = activityLevel ?? currentData?['activityLevel'] ?? 'Moderate';
      updates['dailyGoal'] = _calculateDailyGoal(newWeight, newActivity);
    }

    await _db.collection('user_body').doc(_userId).update(updates);
  }

  /// Calculate daily water goal based on weight and activity level
  double _calculateDailyGoal(double weight, String activityLevel) {
    double activityMultiplier;
    switch (activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.0;
        break;
      case 'Light':
        activityMultiplier = 1.1;
        break;
      case 'Moderate':
        activityMultiplier = 1.2;
        break;
      case 'Active':
        activityMultiplier = 1.3;
        break;
      default:
        activityMultiplier = 1.0;
    }
    return weight * 0.033 * activityMultiplier * 1000; // in ml
  }
}
