import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managestudents/screens/home_page.dart';
import 'package:managestudents/blocs/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('John Louis Academy for teachers')),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (!state.isLoading && state.errorMessage == null) {
            // Navigate if login is successful
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Small screen layout
                return _buildSmallScreenLayout(state);
              } else {
                // Large screen layout
                return _buildLargeScreenLayout(state);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSmallScreenLayout(LoginState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (state.isLoading) const CircularProgressIndicator(),
            if (!state.isLoading)
              ElevatedButton(
                onPressed: () => context.read<LoginCubit>().signIn(
                      _emailController.text,
                      _passwordController.text,
                    ),
                child: const Text('Login'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout(LoginState state) {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (state.isLoading) const CircularProgressIndicator(),
            if (!state.isLoading)
              ElevatedButton(
                onPressed: () => context.read<LoginCubit>().signIn(
                      _emailController.text,
                      _passwordController.text,
                    ),
                child: const Text('Login'),
              ),
          ],
        ),
      ),
    );
  }
}
