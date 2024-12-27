import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUserEmailVerificationSuccessState ||
            state is AuthLoginSuccessActionState ||
            state is AuthGoogleLoginSuccessActionState) {
          print(state);
          GoRouter.of(context).pushNamed(MyAppRouteConstants.wrapperRoute);
        }
      },
      builder: (context, state) {
        print(state);
        return Scaffold(
          appBar: AppBar(
            title: const Text('E-Commerce'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/login.png',
                  width: 500.0,
                  height: 300.0,
                ),
                MyTextField(
                  controller: userNameController,
                  prefixIconData: Icons.person,
                  prefixIconColor: Colors.brown,
                  hintText: 'Name',
                  obsecureText: false,
                  obscuringCharacter: '/',
                  fontSize: 15.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: emailController,
                  prefixIconData: Icons.email,
                  prefixIconColor: Colors.brown,
                  hintText: 'Email',
                  obsecureText: false,
                  obscuringCharacter: '/',
                  fontSize: 15.0,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                  prefixIconData: Icons.lock,
                  prefixIconColor: Colors.brown,
                  obscuringCharacter: '.',
                  fontSize: 15.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  buttonColor: Colors.white,
                  fontColor: Colors.brown.shade800,
                  onPressed: () {
                    authBloc.add(AuthUserCreationLoginButtonClickEvent(
                        email: emailController.text,
                        password: passwordController.text));
                  },
                  buttonName: 'Signup',
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
