import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/driver.dart';
import '../../blocs/driver/driver_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AddDriverScreen extends StatefulWidget {
  final Driver? editDriver;
  const AddDriverScreen({super.key, this.editDriver});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editDriver?.name ?? '');
    _phoneController = TextEditingController(text: widget.editDriver?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final driver = Driver(
        id: widget.editDriver?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        isActive: widget.editDriver?.isActive ?? true,
        createdAt: widget.editDriver?.createdAt ?? DateTime.now(),
      );

      if (widget.editDriver != null) {
        context.read<DriverBloc>().add(UpdateDriverEvent(driver));
      } else {
        context.read<DriverBloc>().add(AddDriverEvent(driver));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if (state is DriverOperationSuccessState) {
          Navigator.of(context).pop();
        } else if (state is DriverErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.editDriver != null ? 'Edit Driver' : 'Add Driver',
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
                        labelText: 'Driver Name *',
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
                  widget.editDriver != null ? 'Update Driver' : 'Save Driver',
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
