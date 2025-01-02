import 'package:e_commerce_application/firebase_options.dart';
import 'package:e_commerce_application/presentation/blocs/auth_bloc.dart';
import 'package:e_commerce_application/routes/app_route_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
      url: 'https://nitxzpjfocjiazstpqdk.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pdHh6cGpmb2NqaWF6c3RwcWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU1NTY0NTgsImV4cCI6MjA1MTEzMjQ1OH0.y03bBOdhYVOYgfGb4YUEVeg67XB8-nIMhEHu7EeoKXE');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final MyAppRouter appRouter = MyAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => AuthBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: MyAppRouter.router,
      ),
    );
  }
}
