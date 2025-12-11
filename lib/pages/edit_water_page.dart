import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/intake_history/intake_history_bloc.dart';
import '../blocs/intake_history/intake_history_event.dart';
import '../blocs/intake_history/intake_history_state.dart';
import '../models/intake_record.dart';

class EditWaterPage extends StatefulWidget {
  final IntakeRecord record;

  const EditWaterPage({super.key, required this.record});

  @override
  State<EditWaterPage> createState() => _EditWaterPageState();
}

class _EditWaterPageState extends State<EditWaterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late String _selectedType;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _drinkTypes = [
    {'name': 'Water', 'emoji': '💧'},
    {'name': 'Tea', 'emoji': '🍵'},
    {'name': 'Coffee', 'emoji': '☕'},
    {'name': 'Juice', 'emoji': '🧃'},
    {'name': 'Milk', 'emoji': '🥛'},
    {'name': 'Other', 'emoji': '🥤'},
  ];

  final List<int> _quickAmounts = [100, 200, 250, 300, 500];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.record.amount.toString());
    _selectedType = widget.record.type;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final updatedRecord = widget.record.copyWith(
      amount: amount,
      type: _selectedType,
    );

    context.read<IntakeHistoryBloc>().add(UpdateIntakeRecord(record: updatedRecord));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntakeHistoryBloc, IntakeHistoryState>(
      listener: (context, state) {
        if (state is IntakeRecordUpdating) {
          setState(() => _isLoading = true);
        } else if (state is IntakeRecordUpdateSuccess) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Record updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is IntakeRecordUpdateError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFA8DAFF), Color(0xFFC7E9FF)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.all(40).copyWith(left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Edit Water Intake',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Recorded at ${widget.record.time}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF999999),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 35),

                          // Drink Type Selection
                          const Text(
                            'Drink Type',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _drinkTypes.map((type) {
                              final isSelected = _selectedType == type['name'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedType = type['name']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF64B5F6)
                                        : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF64B5F6)
                                          : const Color(0xFFE0E0E0),
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        type['emoji'],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        type['name'],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF555555),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 25),

                          // Amount Input
                          const Text(
                            'Amount (ml)',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = int.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter amount in ml',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF999999)),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Quick Amount Buttons
                          const Text(
                            'Quick Select',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _quickAmounts.map((amount) {
                              return OutlinedButton(
                                onPressed: () {
                                  _amountController.text = amount.toString();
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                      color: Color(0xFF64B5F6), width: 2),
                                ),
                                child: Text(
                                  '$amount ml',
                                  style: const TextStyle(
                                    color: Color(0xFF64B5F6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30),

                          // Submit Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF64B5F6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor:
                                  const Color(0xFF64B5F6).withOpacity(0.3),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'SAVE CHANGES',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
