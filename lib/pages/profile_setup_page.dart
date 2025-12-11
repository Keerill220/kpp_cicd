import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'home_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _weightController = TextEditingController();
  String _selectedActivity = 'Moderate';
  final _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _handleActivitySelection(String title) {
    setState(() {
      _selectedActivity = title;
    });
  }

  Future<void> _completeRegistration() async {
    if (_weightController.text.isEmpty) {
      _showErrorDialog('Please enter your weight.');
      return;
    }

    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      _showErrorDialog('Please enter a valid weight.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestoreService.saveUserData(
        weight: weight,
        activityLevel: _selectedActivity,
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Setup Your Profile',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Help us calculate your daily water goal',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF999999),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Weight (kg)',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your weight',
                          hintStyle: const TextStyle(color: Color(0xFF999999)),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Activity Level',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _ActivityOption(
                              emoji: '🛋️',
                              title: 'Sedentary',
                              description: 'Little or no exercise',
                              isSelected: _selectedActivity == 'Sedentary',
                              onTap: () => _handleActivitySelection('Sedentary'),
                              isFirst: true,
                            ),
                            const Divider(height: 1, thickness: 1),
                            _ActivityOption(
                              emoji: '🚶',
                              title: 'Light',
                              description: 'Exercise 1-3 days/week',
                              isSelected: _selectedActivity == 'Light',
                              onTap: () => _handleActivitySelection('Light'),
                            ),
                            const Divider(height: 1, thickness: 1),
                            _ActivityOption(
                              emoji: '🏃',
                              title: 'Moderate',
                              description: 'Exercise 3-5 days/week',
                              isSelected: _selectedActivity == 'Moderate',
                              onTap: () => _handleActivitySelection('Moderate'),
                            ),
                            const Divider(height: 1, thickness: 1),
                            _ActivityOption(
                              emoji: '💪',
                              title: 'Active',
                              description: 'Exercise 6-7 days/week',
                              isSelected: _selectedActivity == 'Active',
                              onTap: () => _handleActivitySelection('Active'),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _completeRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DD0E1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFF4DD0E1).withOpacity(0.3),
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
                                  Text(
                                    'COMPLETE REGISTRATION',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.check, size: 20),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EDDA).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15),
                    border: const Border(
                      left: BorderSide(color: Color(0xFF28A745), width: 4),
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF155724),
                              height: 1.6),
                          children: [
                            TextSpan(
                              text: '📊 Formula: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Daily water intake = Weight × 0.033 × Activity multiplier',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '• Sedentary: 1.0x\n• Light: 1.1x\n• Moderate: 1.2x\n• Active: 1.3x',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF155724),
                          height: 1.8,
                        ),
                      ),
                    ],
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

class _ActivityOption extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _ActivityOption({
    required this.emoji,
    required this.title,
    required this.description,
    required this.onTap,
    this.isSelected = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(10) : Radius.zero,
            bottom: isLast ? const Radius.circular(10) : Radius.zero,
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF1976D2)
                          : const Color(0xFF555555),
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF1976D2), size: 24),
          ],
        ),
      ),
    );
  }
}
