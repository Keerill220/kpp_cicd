import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/intake_history/intake_history_bloc.dart';
import 'blocs/user_progress/user_progress_bloc.dart';
import 'firebase_options.dart';
import 'pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IntakeHistoryBloc()),
        BlocProvider(create: (context) => UserProgressBloc()),
      ],
      child: MaterialApp(
        title: 'HydroCheck',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const WelcomePage(),
      ),
    );
  }
}
