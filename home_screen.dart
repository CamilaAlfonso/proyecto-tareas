import 'dart:math' as logger show e;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _username = ''; // Nombre del usuario
  String _userEmail = ''; // Email del usuario
  List<Map<String, String>> tasks = []; // Lista de tareas

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Obtener los datos del usuario desde el backend
  }

  // Método para obtener los datos del usuario desde el backend
  Future<void> _fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/users/1'),
    ); // Cambiar la URL y el ID del usuario según corresponda

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _username = responseData['name'];
        _userEmail = responseData['email'];
      });
    } else {
      // Manejo de error si no se puede obtener el usuario
      logger.e;
    }
  }

  // Método para agregar tarea
  void _addTask(String title, String status) {
    setState(() {
      tasks.add({'title': title, 'status': status});
    });
  }

  // Método para obtener color del estado de la tarea
  Color _getTaskColor(String status) {
    switch (status) {
      case 'Listo para empezar':
        return Colors.green;
      case 'En curso':
        return Colors.orange;
      case 'Detenido':
        return Colors.red;
      case 'Pendiente':
        return Colors.yellow;
      case 'Terminado':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    _username.isNotEmpty ? _username[0] : 'U',
                  ), // Inicial del nombre si no se ha cargado
                ),
                SizedBox(width: 10),
                Text(
                  _username.isNotEmpty ? _username : 'Cargando...',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _userEmail.isNotEmpty
                  ? _userEmail
                  : 'Cargando...', // Mostrar email
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: _getTaskColor(tasks[index]['status']!),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(tasks[index]['title']!),
                      subtitle: Text('Estado: ${tasks[index]['status']}'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask('Nueva tarea', 'Pendiente');
              },
              child: Text('Agregar Tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
