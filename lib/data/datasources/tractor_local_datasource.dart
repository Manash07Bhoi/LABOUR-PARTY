import 'package:hive/hive.dart';
import '../../core/constants/hive_box_names.dart';
import '../models/tractor_model.dart';

class TractorLocalDatasource {
  final Box<TractorModel> tractorBox = Hive.box<TractorModel>(HiveBoxNames.tractors);

  Future<void> addTractor(TractorModel tractor) async {
    await tractorBox.put(tractor.id, tractor);
  }

  Future<void> updateTractor(TractorModel tractor) async {
    await tractorBox.put(tractor.id, tractor);
  }

  Future<void> deleteTractor(String id) async {
    final tractor = tractorBox.get(id);
    if (tractor != null) {
      // Soft delete
      final deletedTractor = TractorModel(
        id: tractor.id,
        name: tractor.name,
        plateNumber: tractor.plateNumber,
        isActive: false,
        createdAt: tractor.createdAt,
      );
      await tractorBox.put(id, deletedTractor);
    }
  }

  Future<List<TractorModel>> getAllTractors() async {
    return tractorBox.values.where((t) => t.isActive).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<TractorModel?> getTractorById(String id) async {
    return tractorBox.get(id);
  }
}
