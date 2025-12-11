import 'package:equatable/equatable.dart';
import '../../models/intake_record.dart';

abstract class IntakeHistoryEvent extends Equatable {
  const IntakeHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadIntakeHistory extends IntakeHistoryEvent {}

class CreateIntakeRecord extends IntakeHistoryEvent {
  final String time;
  final int amount;
  final String type;

  const CreateIntakeRecord({
    required this.time,
    required this.amount,
    required this.type,
  });

  @override
  List<Object?> get props => [time, amount, type];
}

class UpdateIntakeRecord extends IntakeHistoryEvent {
  final IntakeRecord record;

  const UpdateIntakeRecord({required this.record});

  @override
  List<Object?> get props => [record];
}

class DeleteIntakeRecord extends IntakeHistoryEvent {
  final String recordId;

  const DeleteIntakeRecord({required this.recordId});

  @override
  List<Object?> get props => [recordId];
}
