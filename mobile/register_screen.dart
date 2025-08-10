import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tasks_screen.dart'; // Importar TasksScreen

// Asegúrate de que el widget es público (sin guion bajo)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

// Cambia el nombre de la clase del estado de _RegisterScreenState a RegisterScreenState
class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Validar la contraseña
  bool _validatePassword(String password) {
    RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{6,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Validar el correo
  bool _validateEmail(String email) {
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Método para mostrar mensaje
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

  // Registrar el usuario
  Future<void> _registerUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Por favor completa todos los campos');
      return;
    }

    if (!_validatePassword(password)) {
      _showMessage(
        'La contraseña debe tener al menos 1 mayúscula, 1 número y 6 caracteres',
      );
      return;
    }

    if (!_validateEmail(email)) {
      _showMessage('Por favor ingresa un correo electrónico válido');
      return;
    }

    try {
      // Cambiar localhost por 10.0.2.2 para el emulador
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/users'), // Cambiado a la IP del emulador
        headers: {"Content-Type": "application/json"},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _showMessage(
          'Usuario creado exitosamente: ${responseData['name']}',
        ); // Muestra el nombre del usuario

        // Navegar a la pantalla de tareas después del registro exitoso
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const TasksScreen(),
          ), // Cambiar a la pantalla de tareas
        );
      } else if (response.statusCode == 409) {
        _showMessage('El correo electrónico ya está registrado');
      } else {
        _showMessage('Error al crear el usuario. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en registro: $e');
      _showMessage('Error de conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
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
              onPressed: _registerUser,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
