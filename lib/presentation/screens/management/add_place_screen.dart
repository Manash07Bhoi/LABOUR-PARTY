import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/place.dart';
import '../../blocs/place/place_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AddPlaceScreen extends StatefulWidget {
  final Place? editPlace;
  const AddPlaceScreen({super.key, this.editPlace});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editPlace?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final place = Place(
        id: widget.editPlace?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        isActive: widget.editPlace?.isActive ?? true,
        createdAt: widget.editPlace?.createdAt ?? DateTime.now(),
      );

      if (widget.editPlace != null) {
        context.read<PlaceBloc>().add(UpdatePlaceEvent(place));
      } else {
        context.read<PlaceBloc>().add(AddPlaceEvent(place));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceBloc, PlaceState>(
      listener: (context, state) {
        if (state is PlaceOperationSuccessState) {
          Navigator.of(context).pop();
        } else if (state is PlaceErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.editPlace != null ? 'Edit Place' : 'Add Place',
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GlassCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (val) => Validators.minLength(val, 2, 'Place name must be at least 2 characters'),
                      decoration: const InputDecoration(
                        labelText: 'Place Name *',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: AppColors.accentCyanLight,
                  foregroundColor: const Color(0xFF003740),
                ),
                child: Text(
                  widget.editPlace != null ? 'Update Place' : 'Save Place',
                  style: AppTypography.titleLarge.copyWith(color: const Color(0xFF003740)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
