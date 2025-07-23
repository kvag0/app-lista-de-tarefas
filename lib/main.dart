import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // 1. Variáveis de Estado
  bool _isLoading = true; // Para controlar a exibição do loading
  List<dynamic> _tasks = []; // Para guardar as tarefas vindas da API

  // 2. initState: Método que é chamado UMA VEZ quando o widget é criado.
  // Perfeito para fazer a nossa chamada de API inicial.
  @override
  void initState() {
    super.initState();
    fetchTasks(); // Chama a nossa função para buscar os dados
  }

  // 3. A nossa função para buscar os dados da API
  Future<void> fetchTasks() async {
    // Substitua pelo IP da sua máquina!
    final url = Uri.parse('http://192.168.10.160:3000/api/todos');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // setState: notifica o Flutter que o estado mudou e a UI precisa ser redesenhada
        setState(() {
          _tasks = jsonResponse['data']; // Guarda a lista de tarefas
          _isLoading = false; // Esconde o loading
        });
      } else {
        // Lidar com o erro
        setState(() {
          _isLoading = false;
        });
        print('Falha ao carregar tarefas. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Lidar com erros de conexão
      setState(() {
        _isLoading = false;
      });
      print('Erro de conexão: $e');
    }
  }

  // 4. O método build, que desenha a UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas'), centerTitle: true),
      // Se estiver a carregar, mostra uma roda de progresso.
      // Se não, mostra a lista.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  // O ícone muda com base no status 'completed' da tarefa
                  leading: Icon(
                    task['completed'] ?? false
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.indigo,
                  ),
                  // O texto da tarefa
                  title: Text(task['text']),
                );
              },
            ),
    );
  }
}
