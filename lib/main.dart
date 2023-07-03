import 'package:flutter/material.dart';
import 'data_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      title: 'Task Manager',
      home: const TaskManagerHomeScreen(),
    );
  }
}

class TaskManagerHomeScreen extends StatefulWidget {
  const TaskManagerHomeScreen({Key? key}) : super(key: key);

  @override
  State<TaskManagerHomeScreen> createState() => _TaskManagerHomeScreenState();
}

class _TaskManagerHomeScreenState extends State<TaskManagerHomeScreen> {
  DateTime _dateTime = DateTime.now();



  get index => todos;
 // get removeAt => todos;

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadLineController = TextEditingController();
  //TextEditingController _dateController = TextEditingController();

  List<ToDo> todos = [];

  removeAT(int index) {
    todos.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onLongPress: () {
                        showModalBottomSheetandDelete(
                          ToDo(todos[index].title, todos[index].description,
                              todos[index].deadLine, todos[index].isDone),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.question_mark),
                          title: Text(todos[index].title),
                          subtitle: Text(todos[index].description),
                          trailing: Column(
                            children: [
                              Expanded(
                                  child: Text(
                                      'Remaining: ${todos[index].deadLine.toString()} days')),
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        todos.removeAt(index).title;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      icon: const Icon(Icons.delete))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              //barrierDismissible: false,
              barrierColor: Colors.deepPurple.withOpacity(0.5),
              builder: (context) {
                return AlertDialog(
                  shadowColor: Colors.deepPurple,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  title: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple,
                          border: Border.all()),
                      child: const Text(
                        'Add New Task',
                        style: TextStyle(color: Colors.white),
                      )),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Enter Task title',
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Enter Description',
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(height: 8),
                      //deadline
                      TextField(
                        controller: _deadLineController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Enter deadline',
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(height: 8),

                      //Text('Deadline: ${todos[index]._deadLine}',style: const TextStyle(color: Colors.deepPurple),),
                      // TextButton(onPressed: _showDatePicker, child: const Text('Change Date'))
                    ],
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          elevation: 2,
                          shadowColor: Colors.deepPurple),
                      onPressed: () {
                        // todos.add(ToDo('sss', 'description', 2, false));

                        todos.add(ToDo(
                            _titleController.text,
                            _descriptionController.text,
                            _deadLineController.text,
                            false));
                        if (mounted) {
                          setState(() {});
                        }
                        _titleController.clear();
                        _descriptionController.clear();
                        _deadLineController.clear();

                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 85),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            elevation: 3,
                            shadowColor: Colors.deepPurple),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const SizedBox(width: 10),
                  ],
                );
              },
            );
          },
          label: const Text('Add New Task')),

    );
  }

  void showModalBottomSheetandDelete(todos) {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Task Title: ${todos.title}'),
              Text('Task Descriptions: ${todos.description}'),
              Text('Task Deadline: ${todos.deadLine}'),
              if (todos.isDone = true)
                const Icon(Icons.check_circle_outline)
              else if (todos.isDone = false)
                const Icon(Icons.question_mark),
              //Text(todos.isDone ? Icon(Icons.arrow_circle_right) : Icon(Icons.pending)),
              //Text('Task Status: ${todos[index].isDone}'),
              IconButton(
                onPressed: () {
                  todos.removeAt(index);
                  if (mounted) {
                    setState(() {

                    });
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          );
        });
  }

}