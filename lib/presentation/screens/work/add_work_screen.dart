import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/work.dart';
import '../../blocs/work/work_bloc.dart';
import '../../blocs/place/place_bloc.dart';
import '../../blocs/labour/labour_bloc.dart';
import '../../blocs/driver/driver_bloc.dart';
import '../../blocs/tractor/tractor_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/glass_card.dart';

class AddWorkScreen extends StatefulWidget {
  final Work? editWork;
  const AddWorkScreen({super.key, this.editWork});

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  
  String? _selectedPlaceId;
  String? _selectedPlaceName;
  
  List<String> _selectedLabourIds = [];
  
  String? _selectedDriverId;
  String? _selectedDriverName;
  
  String? _selectedTractorId;
  String? _selectedTractorName;
  
  int _sandTrips = 0;
  
  double _calculatedAmountPerLabour = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editWork?.workName ?? '');
    _amountController = TextEditingController(text: widget.editWork?.totalAmount.toString() ?? '');
    _amountController.addListener(_recalculateAmount);
    
    _selectedDate = widget.editWork?.date ?? DateTime.now();
    
    if (widget.editWork != null) {
      _selectedPlaceId = widget.editWork!.placeId;
      _selectedPlaceName = widget.editWork!.placeName;
      _selectedLabourIds = List.from(widget.editWork!.labourIds);
      _selectedDriverId = widget.editWork!.driverId;
      _selectedDriverName = widget.editWork!.driverName;
      _selectedTractorId = widget.editWork!.tractorId;
      _selectedTractorName = widget.editWork!.tractorName;
      _sandTrips = widget.editWork!.sandTrips;
    }

    // Load necessary data if not already loaded
    context.read<PlaceBloc>().add(LoadPlacesEvent());
    context.read<LabourBloc>().add(LoadLaboursEvent());
    context.read<DriverBloc>().add(LoadDriversEvent());
    context.read<TractorBloc>().add(LoadTractorsEvent());
    
    _recalculateAmount();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _recalculateAmount() {
    final amountText = _amountController.text;
    final totalAmount = double.tryParse(amountText) ?? 0.0;
    
    setState(() {
      if (_selectedLabourIds.isNotEmpty && totalAmount > 0) {
        _calculatedAmountPerLabour = totalAmount / _selectedLabourIds.length;
      } else {
        _calculatedAmountPerLabour = 0.0;
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentCyanLight,
              onPrimary: Color(0xFF003740),
              surface: AppColors.backgroundCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveWork() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPlaceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a work place')),
        );
        return;
      }
      if (_selectedLabourIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least one labourer')),
        );
        return;
      }

      final totalAmount = double.parse(_amountController.text);
      
      final work = Work(
        id: widget.editWork?.id ?? const Uuid().v4(),
        workName: _nameController.text.trim(),
        date: _selectedDate,
        placeId: _selectedPlaceId!,
        placeName: _selectedPlaceName!,
        labourIds: _selectedLabourIds,
        labourCount: _selectedLabourIds.length,
        totalAmount: totalAmount,
        amountPerLabour: 0.0, // Domain layer recalculates this
        driverId: _selectedDriverId,
        driverName: _selectedDriverName,
        tractorId: _selectedTractorId,
        tractorName: _selectedTractorName,
        sandTrips: _sandTrips,
        createdAt: widget.editWork?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.editWork != null) {
        context.read<WorkBloc>().add(UpdateWorkEvent(work));
      } else {
        context.read<WorkBloc>().add(AddWorkEvent(work));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkBloc, WorkState>(
      listener: (context, state) {
        if (state is WorkOperationSuccessState) {
          Navigator.of(context).pop();
        } else if (state is WorkErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.errorRed),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.editWork != null ? 'Edit Work' : 'Add Work',
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildPlaceSelection(),
              const SizedBox(height: 24),
              _buildLabourSelection(),
              const SizedBox(height: 24),
              _buildAmountCalculationCard(),
              const SizedBox(height: 24),
              _buildVehicleSection(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveWork,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: AppColors.accentCyanLight,
                  foregroundColor: const Color(0xFF003740),
                ),
                child: Text(
                  widget.editWork != null ? 'Update Work Record' : 'Save Work Record',
                  style: AppTypography.titleLarge.copyWith(color: const Color(0xFF003740)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Details', style: AppTypography.headlineMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          validator: (val) => Validators.minLength(val, 3, 'Work name must be at least 3 characters'),
          decoration: const InputDecoration(
            labelText: 'Work Name',
            prefixIcon: Icon(Icons.work_outline),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(14),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Work Date',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              DateFormatter.format(_selectedDate),
              style: AppTypography.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Work Place', style: AppTypography.headlineMedium),
        const SizedBox(height: 16),
        BlocBuilder<PlaceBloc, PlaceState>(
          builder: (context, state) {
            if (state is PlaceLoadedState) {
              return DropdownButtonFormField<String>(
                value: _selectedPlaceId,
                decoration: const InputDecoration(
                  labelText: 'Select Place',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                items: state.places.map((p) {
                  return DropdownMenuItem<String>(
                    value: p.place.id,
                    child: Text(p.place.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedPlaceId = val;
                    if (val != null) {
                      _selectedPlaceName = state.places.firstWhere((p) => p.place.id == val).place.name;
                    }
                  });
                },
                validator: (val) => val == null ? 'Please select a work place' : null,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildLabourSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Labours', style: AppTypography.headlineMedium),
            Text(
              '${_selectedLabourIds.length} selected',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.accentCyanLight),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<LabourBloc, LabourState>(
          builder: (context, state) {
            if (state is LabourLoadedState) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.labours.map((l) {
                  final isSelected = _selectedLabourIds.contains(l.labour.id);
                  return FilterChip(
                    label: Text(l.labour.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedLabourIds.add(l.labour.id);
                        } else {
                          _selectedLabourIds.remove(l.labour.id);
                        }
                        _recalculateAmount();
                      });
                    },
                    selectedColor: AppColors.accentCyanLight.withOpacity(0.2),
                    checkmarkColor: AppColors.accentCyanLight,
                  );
                }).toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildAmountCalculationCard() {
    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Details', style: AppTypography.titleLarge),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            validator: (val) => Validators.amount(val, 'Enter a valid amount greater than 0'),
            decoration: const InputDecoration(
              labelText: 'Total Amount',
              prefixIcon: Icon(Icons.currency_rupee),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount per labour:', style: AppTypography.bodyLarge),
              Text(
                CurrencyFormatter.format(_calculatedAmountPerLabour),
                style: AppTypography.moneyDisplay.copyWith(fontSize: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle & Sand Trips', style: AppTypography.headlineMedium),
        const SizedBox(height: 16),
        BlocBuilder<DriverBloc, DriverState>(
          builder: (context, state) {
            if (state is DriverLoadedState) {
              return DropdownButtonFormField<String>(
                value: _selectedDriverId,
                decoration: const InputDecoration(
                  labelText: 'Select Driver (Optional)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text('None')),
                  ...state.drivers.map((d) {
                    return DropdownMenuItem<String>(
                      value: d.driver.id,
                      child: Text(d.driver.name),
                    );
                  }),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedDriverId = val;
                    if (val != null) {
                      _selectedDriverName = state.drivers.firstWhere((d) => d.driver.id == val).driver.name;
                    } else {
                      _selectedDriverName = null;
                    }
                  });
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<TractorBloc, TractorState>(
          builder: (context, state) {
            if (state is TractorLoadedState) {
              return DropdownButtonFormField<String>(
                value: _selectedTractorId,
                decoration: const InputDecoration(
                  labelText: 'Select Tractor (Optional)',
                  prefixIcon: Icon(Icons.agriculture_outlined),
                ),
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text('None')),
                  ...state.tractors.map((t) {
                    return DropdownMenuItem<String>(
                      value: t.tractor.id,
                      child: Text(t.tractor.name),
                    );
                  }),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedTractorId = val;
                    if (val != null) {
                      _selectedTractorName = state.tractors.firstWhere((t) => t.tractor.id == val).tractor.name;
                    } else {
                      _selectedTractorName = null;
                    }
                  });
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text('Sand Trips', style: AppTypography.bodyLarge),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_sandTrips > 0) {
                      setState(() {
                        _sandTrips--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.accentCyanLight,
                ),
                Text(
                  '$_sandTrips',
                  style: AppTypography.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _sandTrips++;
                    });
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.accentCyanLight,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
