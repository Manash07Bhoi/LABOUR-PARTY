import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/place.dart';
import '../../../domain/usecases/place_usecases.dart';
import '../../../domain/usecases/work_usecases.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final GetPlacesWithStatsUseCase getPlacesWithStats;
  final AddPlaceUseCase addPlace;
  final UpdatePlaceUseCase updatePlace;
  final DeletePlaceUseCase deletePlace;
  final GetAllWorksUseCase getAllWorks;

  PlaceBloc({
    required this.getPlacesWithStats,
    required this.addPlace,
    required this.updatePlace,
    required this.deletePlace,
    required this.getAllWorks,
  }) : super(PlaceInitial()) {
    on<LoadPlacesEvent>(_onLoadPlaces);
    on<AddPlaceEvent>(_onAddPlace);
    on<UpdatePlaceEvent>(_onUpdatePlace);
    on<DeletePlaceEvent>(_onDeletePlace);
  }

  Future<void> _onLoadPlaces(LoadPlacesEvent event, Emitter<PlaceState> emit) async {
    emit(PlaceLoadingState());
    try {
      final places = await getPlacesWithStats();
      if (places.isEmpty) {
        emit(PlaceEmptyState());
      } else {
        emit(PlaceLoadedState(places: places));
      }
    } catch (e) {
      emit(PlaceErrorState(e.toString()));
    }
  }

  Future<void> _onAddPlace(AddPlaceEvent event, Emitter<PlaceState> emit) async {
    try {
      await addPlace(event.place);
      emit(const PlaceOperationSuccessState('Place added successfully'));
      add(LoadPlacesEvent());
    } catch (e) {
      emit(PlaceErrorState(e.toString()));
    }
  }

  Future<void> _onUpdatePlace(UpdatePlaceEvent event, Emitter<PlaceState> emit) async {
    try {
      await updatePlace(event.place);
      emit(const PlaceOperationSuccessState('Place updated successfully'));
      add(LoadPlacesEvent());
    } catch (e) {
      emit(PlaceErrorState(e.toString()));
    }
  }

  Future<void> _onDeletePlace(DeletePlaceEvent event, Emitter<PlaceState> emit) async {
    try {
      final works = await getAllWorks();
      final hasReferences = works.any((w) => w.placeId == event.id);

      if (hasReferences) {
        final referenceCount = works.where((w) => w.placeId == event.id).length;
        emit(PlaceDeleteBlockedState('This place is used in $referenceCount work records and cannot be deleted.'));
        add(LoadPlacesEvent()); // reload to restore state
      } else {
        await deletePlace(event.id);
        emit(const PlaceOperationSuccessState('Place deleted successfully'));
        add(LoadPlacesEvent());
      }
    } catch (e) {
      emit(PlaceErrorState(e.toString()));
    }
  }
}
