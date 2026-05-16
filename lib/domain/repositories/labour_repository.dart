import '../entities/labour.dart';

abstract class LabourRepository {
  Future<void> addLabour(Labour labour);
  Future<void> updateLabour(Labour labour);
  Future<void> deleteLabour(String id); // soft delete
  Future<List<Labour>> getAllLabours();
  Future<Labour?> getLabourById(String id);
}
