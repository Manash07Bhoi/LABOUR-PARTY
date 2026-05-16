import '../entities/tractor.dart';

abstract class TractorRepository {
  Future<void> addTractor(Tractor tractor);
  Future<void> updateTractor(Tractor tractor);
  Future<void> deleteTractor(String id); // soft delete
  Future<List<Tractor>> getAllTractors();
  Future<Tractor?> getTractorById(String id);
}
