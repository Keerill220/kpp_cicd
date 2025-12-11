import 'package:equatable/equatable.dart';

abstract class UserProgressState extends Equatable {
  const UserProgressState();

  @override
  List<Object?> get props => [];
}

class UserProgressInitial extends UserProgressState {}

class UserProgressLoading extends UserProgressState {}

class UserProgressLoaded extends UserProgressState {
  final double weight;
  final String activityLevel;
  final int dailyGoal; // in ml
  final int todayIntake; // in ml

  const UserProgressLoaded({
    required this.weight,
    required this.activityLevel,
    required this.dailyGoal,
    required this.todayIntake,
  });

  double get progressPercentage {
    if (dailyGoal == 0) return 0;
    return (todayIntake / dailyGoal).clamp(0.0, 1.0);
  }

  int get remainingIntake => (dailyGoal - todayIntake).clamp(0, dailyGoal);

  @override
  List<Object?> get props => [weight, activityLevel, dailyGoal, todayIntake];
}

class UserProgressError extends UserProgressState {
  final String message;

  const UserProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
