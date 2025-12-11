import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/intake_history/intake_history_bloc.dart';
import '../blocs/intake_history/intake_history_event.dart';
import '../blocs/intake_history/intake_history_state.dart';
import '../blocs/user_progress/user_progress_bloc.dart';
import '../blocs/user_progress/user_progress_event.dart';
import '../blocs/user_progress/user_progress_state.dart';
import 'add_water_page.dart';
import 'edit_water_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<IntakeHistoryBloc>().add(LoadIntakeHistory());
    context.read<UserProgressBloc>().add(LoadUserProgress());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntakeHistoryBloc, IntakeHistoryState>(
      listener: (context, state) {
        // Refresh progress when records are deleted or modified
        if (state is IntakeRecordDeleteSuccess ||
            state is IntakeHistoryLoaded) {
          context.read<UserProgressBloc>().add(RefreshUserProgress());
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 405),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'HydroCheck',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showRandomCatImage(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        "Today's Progress",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(30),
                      margin: EdgeInsets.only(bottom: 20),
                      child: BlocBuilder<UserProgressBloc, UserProgressState>(
                        builder: (context, state) {
                          if (state is UserProgressLoading || state is UserProgressInitial) {
                            return const SizedBox(
                              height: 150,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is UserProgressLoaded) {
                            final percentage = state.progressPercentage * 100;
                            return Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${state.todayIntake} ',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF42A5F5),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/ ${state.dailyGoal}',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'milliliters',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${percentage.toStringAsFixed(1)}% Complete',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: percentage >= 100
                                        ? Color(0xFF4CAF50)
                                        : Color(0xFF4DD0E1),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                        spreadRadius: -2,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: state.progressPercentage,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: percentage >= 100
                                                  ? [Color(0xFF66BB6A), Color(0xFF81C784)]
                                                  : [Color(0xFF64B5F6), Color(0xFF90CAF9)],
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (state is UserProgressError) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<UserProgressBloc>().add(LoadUserProgress());
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddWaterPage()),
                          );
                          // Refresh progress after returning from add page
                          if (mounted) {
                            context.read<UserProgressBloc>().add(RefreshUserProgress());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(18),
                          backgroundColor: Color(0xFF64B5F6),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Color(0xFF64B5F6).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'ADD WATER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Today's Intake History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF64B5F6),
                                  Color(0xFF90CAF9)
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Type',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<IntakeHistoryBloc, IntakeHistoryState>(
                            builder: (context, state) {
                              if (state is IntakeHistoryLoading ||
                                  state is IntakeHistoryInitial) {
                                return const SizedBox(
                                  height: 250,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (state is IntakeHistoryLoaded) {
                                if (state.intakeHistory.isEmpty) {
                                  return const SizedBox(
                                    height: 250,
                                    child: Center(
                                      child: Text(
                                        'No intake records yet.\nTap "ADD WATER" to start tracking!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.intakeHistory.length,
                                    itemBuilder: (context, index) {
                                      final record =
                                          state.intakeHistory[index];
                                      return Column(
                                        children: [
                                          Dismissible(
                                            key: Key(record.id ?? index.toString()),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(right: 20),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                            confirmDismiss: (direction) async {
                                              return await _showDeleteConfirmDialog(context);
                                            },
                                            onDismissed: (direction) {
                                              if (record.id != null) {
                                                context.read<IntakeHistoryBloc>().add(
                                                  DeleteIntakeRecord(recordId: record.id!),
                                                );
                                              }
                                            },
                                            child: InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditWaterPage(record: record),
                                                  ),
                                                );
                                                // Refresh progress after returning from edit page
                                                if (mounted) {
                                                  context.read<UserProgressBloc>().add(RefreshUserProgress());
                                                }
                                              },
                                              child: _intakeRow(
                                                record.time,
                                                record.formattedAmount,
                                                record.type,
                                              ),
                                            ),
                                          ),
                                          if (index <
                                              state.intakeHistory.length - 1)
                                            _divider(),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              } else if (state is IntakeHistoryError) {
                                return SizedBox(
                                  height: 250,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Failed to load intake history.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<IntakeHistoryBloc>()
                                                .add(LoadIntakeHistory());
                                          },
                                          child: const Text('Retry'),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _intakeRow(String time, String amount, String type) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF42A5F5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              type,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Color(0xFFF0F0F0),
    );
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this intake record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _showRandomCatImage(BuildContext context) async {
    // Generate random number 1-5
    final random = Random();
    final catNumber = random.nextInt(5) + 1;
    final imageName = 'cat$catNumber.jpg';

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get download URL from Firebase Storage
      final storage = FirebaseStorage.instance;
      debugPrint('Storage bucket: ${storage.bucket}');
      debugPrint('Trying to get: $imageName');
      
      final ref = storage.ref(imageName);
      debugPrint('Reference path: ${ref.fullPath}');
      
      final imageUrl = await ref.getDownloadURL();
      debugPrint('Got URL: $imageUrl');

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show cat image dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Random Cat! 🐱'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(
                          child: Icon(Icons.error, color: Colors.red, size: 50),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  imageName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Firebase Storage Error: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cat image: $e')),
        );
      }
    }
  }
}