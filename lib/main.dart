import 'package:e_commerce_application/firebase_options.dart';
import 'package:e_commerce_application/presentation/blocs/auth_bloc.dart';
import 'package:e_commerce_application/routes/app_route_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        // BlocProvider(create: (ctx) => AdminProductFormBloc(firestore: FirebaseFirestore.instance, adminEmail: )),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: MyAppRouter.router,
      ),
    );
  }
}
