import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth/auth_bloc.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    // final authBloc = context.watch<AuthBloc>();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state is AuthAdminLoginSuccessState) {
        //   GoRouter.of(context).pushNamed(MyAppRouteConstants.wrapperRoute);
        // }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Image.asset(
                'assets/login.png',
                height: 500.0,
                width: 500.0,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                    color: (Colors.brown)),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Login'),
                          content: const Text('Login as '),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  context.pushNamed(
                                      MyAppRouteConstants.loginRoute,
                                      extra: true);
                                },
                                child: const Text('Admin')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  context.pushNamed(
                                      MyAppRouteConstants.loginRoute,
                                      extra: false);
                                },
                                child: const Text('User'))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.person),
                label: const Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 19),
                ),
                style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.brown[400]),
                    foregroundColor:
                        WidgetStateProperty.all(Colors.brown.shade600),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    fixedSize: WidgetStateProperty.all(Size(400, 50))),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(MyAppRouteConstants.signupRoute);
                },
                icon: const Icon(Icons.person),
                label: const Text(
                  'SIGN UP',
                  style: TextStyle(fontSize: 19),
                ),
                style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.brown[400]),
                    foregroundColor:
                        WidgetStateProperty.all(Colors.brown.shade600),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    fixedSize: WidgetStateProperty.all(Size(400, 50))),
              ),
            ],
          ),
        );
      },
    );
  }
}
