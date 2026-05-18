import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/tractor.dart';
import '../../blocs/tractor/tractor_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AddTractorScreen extends StatefulWidget {
  final Tractor? editTractor;
  const AddTractorScreen({super.key, this.editTractor});

  @override
  State<AddTractorScreen> createState() => _AddTractorScreenState();
}

class _AddTractorScreenState extends State<AddTractorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _plateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editTractor?.name ?? '');
    _plateController = TextEditingController(text: widget.editTractor?.plateNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final tractor = Tractor(
        id: widget.editTractor?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        plateNumber: _plateController.text.trim(),
        isActive: widget.editTractor?.isActive ?? true,
        createdAt: widget.editTractor?.createdAt ?? DateTime.now(),
      );

      if (widget.editTractor != null) {
        context.read<TractorBloc>().add(UpdateTractorEvent(tractor));
      } else {
        context.read<TractorBloc>().add(AddTractorEvent(tractor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TractorBloc, TractorState>(
      listener: (context, state) {
        if (state is TractorOperationSuccessState) {
          Navigator.of(context).pop();
        } else if (state is TractorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_nameController.text.isNotEmpty || _plateController.text.isNotEmpty) {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Discard changes?', style: AppTypography.titleLarge.copyWith(color: AppColors.warningAmber)),
                content: Text('Your progress will be lost.', style: AppTypography.bodyMedium),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text('Keep Editing', style: AppTypography.labelLarge),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('Discard', style: AppTypography.labelLarge.copyWith(color: AppColors.errorRed)),
                  ),
                ],
              ),
            );
            if (shouldPop ?? false) {
              if (context.mounted) Navigator.of(context).pop();
            }
          } else {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: widget.editTractor != null ? 'Edit Tractor' : 'Add Tractor',
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
                      validator: (val) => Validators.minLength(val, 2, 'Name must be at least 2 characters'),
                      decoration: const InputDecoration(
                        labelText: 'Tractor Name *',
                        prefixIcon: Icon(Icons.agriculture_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _plateController,
                      decoration: const InputDecoration(
                        labelText: 'Plate Number (Optional)',
                        prefixIcon: Icon(Icons.pin_outlined),
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
                  widget.editTractor != null ? 'Update Tractor' : 'Save Tractor',
                  style: AppTypography.titleLarge.copyWith(color: const Color(0xFF003740)),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
