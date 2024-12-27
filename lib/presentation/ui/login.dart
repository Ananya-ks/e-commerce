import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class Login extends StatefulWidget {
  final bool isAdmin;

  const Login({super.key, required this.isAdmin});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAdminLoginSuccessState) {
          print('admin loggedin');
          GoRouter.of(context).pushNamed(MyAppRouteConstants.wrapperRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isAdmin ? 'Admin Login' : 'User login'),
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
                  controller: emailController,
                  prefixIconData: Icons.email,
                  prefixIconColor: Colors.brown.shade800,
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
                  prefixIconColor: Colors.brown.shade800,
                  obscuringCharacter: '.',
                  fontSize: 15.0,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Forget password',
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    buttonName: 'Login',
                    buttonColor: Colors.white,
                    fontColor: Colors.brown,
                    onPressed: () {
                      print('login admin ${widget.isAdmin}');
                      if (widget.isAdmin) {
                        authBloc.add(AuthAdminLoginEvent(
                            email: emailController.text,
                            password: passwordController.text));
                      } else {
                        authBloc.add(AuthUserLoginEvent(
                            email: emailController.text,
                            password: passwordController.text));
                      }
                    }),
                widget.isAdmin == false
                    ? MyButton(
                        buttonName: 'Sign in with Google',
                        buttonColor: Colors.red,
                        fontColor: Colors.white,
                        onPressed: () {
                          authBloc.add(AuthUserGoogleLoginEvent());
                        })
                    : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      widget.isAdmin == false ?
                      TextSpan(
                          text: 'Don\'t have an account?  ',
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: 'Create',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushNamed(
                                        MyAppRouteConstants.signupRoute);
                                  })
                          ]):
                           TextSpan(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
