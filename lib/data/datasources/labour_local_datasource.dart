import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../models/labour_model.dart';

class LabourLocalDatasource {
  final Box<LabourModel> labourBox = Hive.box<LabourModel>(HiveBoxNames.labours);

  Future<void> addLabour(LabourModel labour) async {
    await labourBox.put(labour.id, labour);
  }

  Future<void> updateLabour(LabourModel labour) async {
    await labourBox.put(labour.id, labour);
  }

  Future<void> deleteLabour(String id) async {
    final labour = labourBox.get(id);
    if (labour != null) {
      // Soft delete
      final deletedLabour = LabourModel(
        id: labour.id,
        name: labour.name,
        phone: labour.phone,
        isActive: false,
        createdAt: labour.createdAt,
      );
      await labourBox.put(id, deletedLabour);
    }
  }

  Future<List<LabourModel>> getAllLabours() async {
    return labourBox.values.where((l) => l.isActive).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<LabourModel?> getLabourById(String id) async {
    return labourBox.get(id);
  }
}
