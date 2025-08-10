import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = []; // Lista de tareas
  final _titleController = TextEditingController();
  final _startTimeController = TextEditingController();
  String _selectedStatus = 'Pendiente'; // Estado por defecto
  String _selectedPriority = 'Media'; // Prioridad por defecto

  // Colores para los estados de las tareas
  final Map<String, Color> statusColors = {
    'Listo para empezar': Colors.green,
    'En curso': Colors.orange,
    'Detenido': Colors.red,
    'Pendiente': Colors.yellow,
    'Terminado': Colors.blue,
  };

  // Colores para las prioridades
  final Map<String, Color> priorityColors = {
    'Alta': Colors.red,
    'Media': Colors.orange,
    'Baja': Colors.green,
    'Critica': Colors.purple,
    'Maximo esfuerzo': Colors.blueGrey,
  };

  // Método para agregar tarea
  Future<void> _addTask() async {
    final title = _titleController.text;
    final startTime = _startTimeController.text;

    if (title.isEmpty || startTime.isEmpty) {
      _showMessage('Por favor ingresa el título y la hora de inicio');
      return;
    }

    // Realizar solicitud POST para agregar la tarea
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/tasks'), // Cambiar la URL al backend
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'title': title,
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'startTime': startTime,
        'totalHours': 0,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      setState(() {
        tasks.add({
          'title': responseData['title'],
          'status': responseData['status'],
          'priority': responseData['priority'],
          'startTime': responseData['startTime'],
          'totalHours': 0,
        });
      });
      _showMessage('Tarea creada exitosamente');
    } else {
      _showMessage('Error al crear la tarea');
    }
  }

  // Método para mostrar mensajes de éxito o error
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Información'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Obtener color basado en el estado
  Color _getTaskStatusColor(String status) {
    return statusColors[status] ??
        Colors.black; // Color por defecto si no se encuentra
  }

  // Obtener color basado en la prioridad
  Color _getTaskPriorityColor(String priority) {
    return priorityColors[priority] ??
        Colors.black; // Color por defecto si no se encuentra
  }

  // Mostrar el selector de hora (reloj)
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _startTimeController.text = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para el título de la tarea
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título de la tarea',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Campo para la hora de inicio de la tarea (con el selector de reloj)
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(
                labelText: 'Hora de inicio (HH:mm)',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectTime(context), // Selección de hora
            ),
            SizedBox(height: 10),

            // Dropdown para seleccionar el estado de la tarea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estado:'),
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                  items:
                      <String>[
                        'Pendiente',
                        'En curso',
                        'Listo para empezar',
                        'Terminado',
                        'Detenido',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Dropdown para seleccionar la prioridad de la tarea
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Prioridad:'),
                DropdownButton<String>(
                  value: _selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items:
                      <String>[
                        'Alta',
                        'Media',
                        'Baja',
                        'Critica',
                        'Maximo esfuerzo',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Botón para agregar la tarea
            ElevatedButton(onPressed: _addTask, child: Text('Agregar Tarea')),

            // Listado de tareas (después de agregar)
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    color: _getTaskStatusColor(tasks[index]['status']!),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(tasks[index]['title']!),
                      subtitle: Text(
                        'Estado: ${tasks[index]['status']} | Prioridad: ${tasks[index]['priority']} | Hora de inicio: ${tasks[index]['startTime']}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
