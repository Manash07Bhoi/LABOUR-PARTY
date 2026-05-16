import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../models/work_model.dart';

class WorkLocalDatasource {
  final Box<WorkModel> workBox = Hive.box<WorkModel>(HiveBoxNames.works);

  Future<void> addWork(WorkModel work) async {
    await workBox.put(work.id, work);
  }

  Future<void> updateWork(WorkModel work) async {
    await workBox.put(work.id, work);
  }

  Future<void> deleteWork(String id) async {
    await workBox.delete(id);
  }

  Future<List<WorkModel>> getAllWorks() async {
    return workBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<WorkModel?> getWorkById(String id) async {
    return workBox.get(id);
  }

  Future<List<WorkModel>> getWorksByDateRange(DateTime start, DateTime end) async {
    final allWorks = workBox.values.toList();
    return allWorks.where((work) {
      return work.date.isAfter(start.subtract(const Duration(days: 1))) &&
          work.date.isBefore(end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
