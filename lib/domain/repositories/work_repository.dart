import '../entities/work.dart';

abstract class WorkRepository {
  Future<void> addWork(Work work);
  Future<void> updateWork(Work work);
  Future<void> deleteWork(String id);
  Future<List<Work>> getAllWorks();
  Future<Work?> getWorkById(String id);
  Future<List<Work>> getWorksByDateRange(DateTime start, DateTime end);
}
