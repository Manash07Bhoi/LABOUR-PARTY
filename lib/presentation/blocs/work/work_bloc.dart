import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/work.dart';
import '../../../domain/usecases/work_usecases.dart';
import '../../../domain/usecases/labour_usecases.dart';

part 'work_event.dart';
part 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  final GetAllWorksUseCase getAllWorks;
  final AddWorkUseCase addWork;
  final UpdateWorkUseCase updateWork;
  final DeleteWorkUseCase deleteWork;
  final GetAllLaboursUseCase getAllLabours;

  List<Work> _allWorks = [];

  WorkBloc({
    required this.getAllWorks,
    required this.addWork,
    required this.updateWork,
    required this.deleteWork,
    required this.getAllLabours,
  }) : super(WorkInitial()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<LoadAllWorksEvent>(_onLoadAllWorks);
    on<SearchWorksEvent>(_onSearchWorks);
    on<AddWorkEvent>(_onAddWork);
    on<UpdateWorkEvent>(_onUpdateWork);
    on<DeleteWorkEvent>(_onDeleteWork);
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Future<void> _onLoadDashboardData(LoadDashboardDataEvent event, Emitter<WorkState> emit) async {
    emit(WorkLoadingState());
    try {
      final works = await getAllWorks();

      if (works.isEmpty) {
        emit(WorkEmptyState());
        return;
      }

      final now = DateTime.now();
      final todayWorks = works.where((w) => _isSameDay(w.date, now)).toList();

      // Today's labour count (unique)
      final Set<String> todayLabourIds = {};
      final Set<String> activeDriverIds = {};

      for (var w in todayWorks) {
        todayLabourIds.addAll(w.labourIds);
        if (w.driverId != null) {
          activeDriverIds.add(w.driverId!);
        }
      }

      double todayTotalAmount = 0;
      int todaySandTrips = 0;
      for (var w in todayWorks) {
        todayTotalAmount += w.totalAmount;
        todaySandTrips += w.sandTrips;
      }

      // Recent activities: all works sorted by createdAt descending
      final recentWorks = List<Work>.from(works)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final recent8Works = recentWorks.take(8).toList();

      emit(DashboardLoadedState(
        recentWorks: recent8Works,
        todayWorksCount: todayWorks.length,
        totalSpent: todayTotalAmount,
        totalSandTrips: todaySandTrips,
        activeDrivers: activeDriverIds.length,
        todayLaboursCount: todayLabourIds.length,
      ));
    } catch (e) {
      emit(WorkErrorState(e.toString()));
    }
  }

  Future<void> _onLoadAllWorks(LoadAllWorksEvent event, Emitter<WorkState> emit) async {
    emit(WorkLoadingState());
    try {
      _allWorks = await getAllWorks();
      if (_allWorks.isEmpty) {
        emit(WorkEmptyState());
      } else {
        emit(WorkListLoadedState(works: _allWorks));
      }
    } catch (e) {
      emit(WorkErrorState(e.toString()));
    }
  }

  Future<void> _onSearchWorks(SearchWorksEvent event, Emitter<WorkState> emit) async {
    if (state is! WorkListLoadedState && _allWorks.isEmpty) return;
    
    final term = event.query.toLowerCase();
    if (term.isEmpty) {
      emit(WorkListLoadedState(works: _allWorks));
      return;
    }

    final filteredWorks = _allWorks.where((w) {
      return w.workName.toLowerCase().contains(term) ||
          w.placeName.toLowerCase().contains(term);
    }).toList();

    if (filteredWorks.isEmpty) {
      emit(WorkEmptyState());
    } else {
      emit(WorkListLoadedState(works: filteredWorks));
    }
  }

  Future<void> _onAddWork(AddWorkEvent event, Emitter<WorkState> emit) async {
    try {
      await addWork(event.work);
      emit(const WorkOperationSuccessState('Work record added successfully'));
      add(LoadAllWorksEvent());
    } catch (e) {
      emit(WorkErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateWork(UpdateWorkEvent event, Emitter<WorkState> emit) async {
    try {
      await updateWork(event.work);
      emit(const WorkOperationSuccessState('Work record updated successfully'));
      add(LoadAllWorksEvent());
    } catch (e) {
      emit(WorkErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteWork(DeleteWorkEvent event, Emitter<WorkState> emit) async {
    try {
      await deleteWork(event.id);
      emit(const WorkOperationSuccessState('Work record deleted successfully'));
      add(LoadAllWorksEvent());
    } catch (e) {
      emit(WorkErrorState(e.toString()));
    }
  }
}
