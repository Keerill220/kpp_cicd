import 'package:equatable/equatable.dart';
import '../../models/intake_record.dart';

abstract class IntakeHistoryState extends Equatable {
  const IntakeHistoryState();

  @override
  List<Object?> get props => [];
}

class IntakeHistoryInitial extends IntakeHistoryState {}

class IntakeHistoryLoading extends IntakeHistoryState {}

class IntakeHistoryLoaded extends IntakeHistoryState {
  final List<IntakeRecord> intakeHistory;
  final int todayTotal;

  const IntakeHistoryLoaded(this.intakeHistory, {this.todayTotal = 0});

  @override
  List<Object?> get props => [intakeHistory, todayTotal];
}

class IntakeHistoryError extends IntakeHistoryState {
  final String message;

  const IntakeHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class IntakeRecordCreating extends IntakeHistoryState {}

class IntakeRecordCreateSuccess extends IntakeHistoryState {
  final IntakeRecord createdRecord;

  const IntakeRecordCreateSuccess(this.createdRecord);

  @override
  List<Object?> get props => [createdRecord];
}

class IntakeRecordCreateError extends IntakeHistoryState {
  final String message;

  const IntakeRecordCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

class IntakeRecordUpdating extends IntakeHistoryState {}

class IntakeRecordUpdateSuccess extends IntakeHistoryState {
  final IntakeRecord updatedRecord;

  const IntakeRecordUpdateSuccess(this.updatedRecord);

  @override
  List<Object?> get props => [updatedRecord];
}

class IntakeRecordUpdateError extends IntakeHistoryState {
  final String message;

  const IntakeRecordUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

class IntakeRecordDeleting extends IntakeHistoryState {}

class IntakeRecordDeleteSuccess extends IntakeHistoryState {
  final String deletedRecordId;

  const IntakeRecordDeleteSuccess(this.deletedRecordId);

  @override
  List<Object?> get props => [deletedRecordId];
}

class IntakeRecordDeleteError extends IntakeHistoryState {
  final String message;

  const IntakeRecordDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}
