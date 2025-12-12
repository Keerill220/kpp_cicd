import 'package:bloc/bloc.dart';
import '../../models/intake_record.dart';
import '../../repositories/intake_repository.dart';

import 'intake_history_event.dart';
import 'intake_history_state.dart';

class IntakeHistoryBloc extends Bloc<IntakeHistoryEvent, IntakeHistoryState> {
  final IntakeRepository _repository;

  IntakeHistoryBloc({IntakeRepository? repository})
      : _repository = repository ?? IntakeRepository(),
        super(IntakeHistoryInitial()) {
    on<LoadIntakeHistory>(_onLoadIntakeHistory);
    on<CreateIntakeRecord>(_onCreateIntakeRecord);
    on<UpdateIntakeRecord>(_onUpdateIntakeRecord);
    on<DeleteIntakeRecord>(_onDeleteIntakeRecord);
  }

  Future<void> _onLoadIntakeHistory(
    LoadIntakeHistory event,
    Emitter<IntakeHistoryState> emit,
  ) async {
    emit(IntakeHistoryLoading());
    try {
      // Fetch only today's records (device timezone)
      final intakeHistory = await _repository.fetchTodayIntakeRecords();
      final todayTotal = await _repository.getTodayTotalIntake();
      emit(IntakeHistoryLoaded(intakeHistory, todayTotal: todayTotal));
    } catch (e) {
      emit(IntakeHistoryError(e.toString()));
    }
  }

  Future<void> _onCreateIntakeRecord(
    CreateIntakeRecord event,
    Emitter<IntakeHistoryState> emit,
  ) async {
    emit(IntakeRecordCreating());
    try {
      final newRecord = IntakeRecord(
        time: event.time,
        amount: event.amount,
        type: event.type,
      );
      final createdRecord = await _repository.createIntakeRecord(newRecord);
      emit(IntakeRecordCreateSuccess(createdRecord));
      
      add(LoadIntakeHistory());
    } catch (e) {
      emit(IntakeRecordCreateError(e.toString()));
    }
  }

  Future<void> _onUpdateIntakeRecord(
    UpdateIntakeRecord event,
    Emitter<IntakeHistoryState> emit,
  ) async {
    emit(IntakeRecordUpdating());
    try {
      await _repository.updateIntakeRecord(event.record);
      emit(IntakeRecordUpdateSuccess(event.record));
      
      add(LoadIntakeHistory());
    } catch (e) {
      emit(IntakeRecordUpdateError(e.toString()));
    }
  }

  Future<void> _onDeleteIntakeRecord(
    DeleteIntakeRecord event,
    Emitter<IntakeHistoryState> emit,
  ) async {
    emit(IntakeRecordDeleting());
    try {
      await _repository.deleteIntakeRecord(event.recordId);
      emit(IntakeRecordDeleteSuccess(event.recordId));
      
      add(LoadIntakeHistory());
    } catch (e) {
      emit(IntakeRecordDeleteError(e.toString()));
    }
  }
}
