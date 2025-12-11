import 'package:bloc/bloc.dart';
import '../../repositories/intake_repository.dart';
import '../../services/firestore_service.dart';

import 'user_progress_event.dart';
import 'user_progress_state.dart';

class UserProgressBloc extends Bloc<UserProgressEvent, UserProgressState> {
  final FirestoreService _firestoreService;
  final IntakeRepository _intakeRepository;

  UserProgressBloc({
    FirestoreService? firestoreService,
    IntakeRepository? intakeRepository,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _intakeRepository = intakeRepository ?? IntakeRepository(),
        super(UserProgressInitial()) {
    on<LoadUserProgress>(_onLoadUserProgress);
    on<RefreshUserProgress>(_onRefreshUserProgress);
  }

  Future<void> _onLoadUserProgress(
    LoadUserProgress event,
    Emitter<UserProgressState> emit,
  ) async {
    emit(UserProgressLoading());
    await _loadProgress(emit);
  }

  Future<void> _onRefreshUserProgress(
    RefreshUserProgress event,
    Emitter<UserProgressState> emit,
  ) async {
    await _loadProgress(emit);
  }

  Future<void> _loadProgress(Emitter<UserProgressState> emit) async {
    try {
      final userData = await _firestoreService.getUserData();
      final todayTotal = await _intakeRepository.getTodayTotalIntake();

      if (userData == null) {
        emit(const UserProgressError('User data not found. Please complete your profile setup.'));
        return;
      }

      final weight = (userData['weight'] as num?)?.toDouble() ?? 70.0;
      final activityLevel = userData['activityLevel'] as String? ?? 'Moderate';
      final dailyGoal = (userData['dailyGoal'] as num?)?.toInt() ?? 2000;

      emit(UserProgressLoaded(
        weight: weight,
        activityLevel: activityLevel,
        dailyGoal: dailyGoal,
        todayIntake: todayTotal,
      ));
    } catch (e) {
      emit(UserProgressError(e.toString()));
    }
  }
}
