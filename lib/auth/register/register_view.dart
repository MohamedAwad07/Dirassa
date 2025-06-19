import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/auth_cubit.dart';
import '../../core/utils/app_strings.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerTitle)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/register.png', height: 80),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: AppStrings.loginEmail,
                      prefixIcon: Image.asset(
                        'assets/icons/login icons/mail.png',
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: AppStrings.loginPassword,
                      prefixIcon: Image.asset(
                        'assets/icons/login icons/lock.png',
                        height: 24,
                      ),
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          _obscureText
                              ? 'assets/icons/login icons/eye.png'
                              : 'assets/icons/login icons/eye.png',
                          height: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state is AuthLoading) const CircularProgressIndicator(),
                  if (state is AuthError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            context.read<AuthCubit>().register(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                    child: const Text(AppStrings.registerButton),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(AppStrings.registerHasAccount),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
