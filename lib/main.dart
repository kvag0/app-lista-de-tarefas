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

  // Adicione esta função dentro da classe _TaskListScreenState
  Future<void> updateTask(String id, bool currentStatus) async {
    // Substitua pelo IP da sua máquina!
    final url = Uri.parse('http://192.168.10.160:3000/api/todos/$id');
    try {
      final response = await http.put(
        url,
        // Cabeçalho para informar a API que estamos a enviar JSON
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        // Corpo do pedido com o novo estado de 'completed'
        body: jsonEncode({'completed': !currentStatus}),
      );

      if (response.statusCode == 200) {
        // Se a API confirmar a alteração, buscamos a lista novamente
        // para garantir que a UI está 100% sincronizada com o banco de dados.
        await fetchTasks();
      } else {
        print(
          'Falha ao atualizar a tarefa. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erro de conexão ao atualizar tarefa: $e');
    }
  }

  // Adicione esta função dentro da classe _TaskListScreenState
  Future<void> _showAddTaskDialog() async {
    // Um controller para ler o texto do campo de input
    final TextEditingController textFieldController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Nova Tarefa'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(
              hintText: "Digite o texto da tarefa",
            ),
            autofocus: true, // Foca no campo de texto automaticamente
          ),
          actions: <Widget>[
            // Botão de Cancelar
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo
              },
            ),
            // Botão de Adicionar
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final String taskText = textFieldController.text;
                // Só adiciona se o texto não estiver vazio
                if (taskText.isNotEmpty) {
                  createTask(taskText); // Chama a função que fará o POST
                  Navigator.of(dialogContext).pop(); // Fecha o diálogo
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Adicione esta função dentro da classe _TaskListScreenState
  Future<void> createTask(String text) async {
    // Substitua pelo IP da sua máquina!
    final url = Uri.parse('http://192.168.10.160:3000/api/todos');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'text': text}), // Enviamos o texto da nova tarefa
      );

      if (response.statusCode == 201) {
        // 201 Created é a resposta padrão para um POST bem-sucedido
        await fetchTasks(); // Recarrega a lista para mostrar a nova tarefa
      } else {
        print('Falha ao criar a tarefa. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de conexão ao criar tarefa: $e');
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
          : _tasks
                .isEmpty // <- AQUI ESTÁ A NOVA VERIFICAÇÃO
          ? const Center(
              child: Text(
                'Nenhuma tarefa encontrada!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              // O nosso ListView.builder atual
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
                  onTap: () {
                    updateTask(task['_id'], task['completed'] ?? false);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Esta função irá abrir o nosso diálogo de adição
          _showAddTaskDialog();
        },
        tooltip: 'Adicionar Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
