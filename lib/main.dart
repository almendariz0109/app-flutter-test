import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login POC',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login exitoso'),
          content: const Text('Bienvenido, admin'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Credenciales incorrectas'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 300, // o cualquier valor que desees
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                obscureText: true,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300, // que el botón ocupe todo el ancho
              height: 48,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
