import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  int limit = 10;
  int skip = 0;

  Future<void> fetchTasks() async {
    var url = Uri.parse('https://dummyjson.com/todos?limit=$limit&skip=$skip');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      tasks = List<Task>.from(data.map((task) => Task(
        id: task['id'],
        title: task['title'],
        completed: task['completed'],
      )));

      setState(() {});
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void nextPage() {
    skip += limit;
    fetchTasks();
  }

  void previousPage() {
    skip -= limit;
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].completed ? 'Completed' : 'Not Completed'),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: skip <= 0 ? null : previousPage,
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: nextPage,
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

