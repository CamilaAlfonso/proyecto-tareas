import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tasks_screen.dart'; // Pantalla a la que se navegará si el login es exitoso
import 'register_screen.dart'; // Importa la pantalla de registro

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Método para mostrar el mensaje
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Información'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Cierra el diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Validar el correo
  bool _validateEmail(String email) {
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Validar la contraseña
  bool _validatePassword(String password) {
    RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{6,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Iniciar sesión
  Future<void> _loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Por favor completa todos los campos');
      return;
    }

    if (!_validateEmail(email)) {
      _showMessage('Por favor ingresa un correo electrónico válido');
      return;
    }

    if (!_validatePassword(password)) {
      _showMessage(
        'La contraseña debe tener al menos 1 mayúscula, 1 número y 6 caracteres',
      );
      return;
    }

    // Cambiar localhost por 10.0.2.2 para el emulador
    final response = await http.post(
      Uri.parse(
        'http://10.0.2.2:3000/users/login',
      ), // Cambiar a la URL correcta del backend
      headers: {"Content-Type": "application/json"},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, navegar a la pantalla de tareas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TasksScreen()),
      );
    } else if (response.statusCode == 409) {
      _showMessage('El correo electrónico ya está registrado');
    } else if (response.statusCode == 401) {
      _showMessage('Correo o contraseña incorrectos');
    } else {
      _showMessage('Error al iniciar sesión');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Iniciar Sesión'),
            ),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: Text('¿No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
