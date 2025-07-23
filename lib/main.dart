import 'package:flutter/material.dart';

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

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  // Nossa lista de dados falsos
  final List<String> tasks = const [
    'Comprar leite',
    'Terminar o projeto Flutter',
    'Passear com o cachorro',
    'Ligar para a mamãe',
    'Ler um capítulo do livro',
    'Fazer exercício',
    'Pagar a conta de luz',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas'), centerTitle: true),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(tasks[index]),
            onTap: () {
              print('"${tasks[index]}" foi tocado!');
            },
          );
        },
      ),
    );
  }
}
