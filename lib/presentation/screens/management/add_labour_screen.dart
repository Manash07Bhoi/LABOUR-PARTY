import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/labour.dart';
import '../../blocs/labour/labour_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AddLabourScreen extends StatefulWidget {
  final Labour? editLabour;
  const AddLabourScreen({super.key, this.editLabour});

  @override
  State<AddLabourScreen> createState() => _AddLabourScreenState();
}

class _AddLabourScreenState extends State<AddLabourScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editLabour?.name ?? '');
    _phoneController = TextEditingController(text: widget.editLabour?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final labour = Labour(
        id: widget.editLabour?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        isActive: widget.editLabour?.isActive ?? true,
        createdAt: widget.editLabour?.createdAt ?? DateTime.now(),
      );

      if (widget.editLabour != null) {
        context.read<LabourBloc>().add(UpdateLabourEvent(labour));
      } else {
        context.read<LabourBloc>().add(AddLabourEvent(labour));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LabourBloc, LabourState>(
      listener: (context, state) {
        if (state is LabourOperationSuccessState) {
          Navigator.of(context).pop();
        } else if (state is LabourErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_nameController.text.isNotEmpty || _phoneController.text.isNotEmpty) {
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
            title: widget.editLabour != null ? 'Edit Labourer' : 'Add Labourer',
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
                        labelText: 'Labour Name *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => Validators.phone(val, 'Enter a valid 10-digit phone number'),
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
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
                  widget.editLabour != null ? 'Update Labourer' : 'Save Labourer',
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
