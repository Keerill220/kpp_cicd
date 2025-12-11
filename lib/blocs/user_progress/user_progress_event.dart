import 'package:equatable/equatable.dart';

abstract class UserProgressEvent extends Equatable {
  const UserProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProgress extends UserProgressEvent {}

class RefreshUserProgress extends UserProgressEvent {}
