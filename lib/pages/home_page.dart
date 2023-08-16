import 'package:flutter/material.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/widgets/todo_item.dart';

import '../widgets/search_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _newTask = false;
  final _textEditingController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final List<ToDo> todoList = ToDo.todoList();
  List<ToDo> _foundToDoList = [];

  @override
  void initState() {
    _foundToDoList = todoList;
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      if (_newTask) {
        _animationController.reverse().whenComplete(() {
          setState(() {
            _newTask = false;
            _textEditingController.clear();
          });
        });
      } else {
        _newTask = true;
        _animationController.forward();
      }
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(ToDo todo) {
    setState(() {
      todoList.removeWhere((element) => element.id == todo.id);
    });
  }

  void _searchToDoItem(String value) {
    List<ToDo> result;

    if (value.isEmpty) {
      result = todoList;
    } else {
      result = todoList
          .where((element) =>
              element.description!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDoList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _newTask = true;
            _animationController.forward();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SearchBox(
                onChange: _searchToDoItem,
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: changeVisibilityNewToDo(),
              ),
              generateToDoList(),
            ],
          ),
        ),
      ),
    );
  }

  Visibility changeVisibilityNewToDo() {
    return Visibility(
      visible: _newTask,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          title: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: TextField(
              autofocus: true,
              onSubmitted: (value) {
                _toggleVisibility();
                setState(() {
                  _foundToDoList.insert(
                      0,
                      ToDo(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        description: value,
                        isDone: false,
                      ));
                });
              },
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'New To Do',
                hintStyle: TextStyle(
                  color: hintText,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          leading: const Checkbox(
            value: false,
            onChanged: null,
          ),
          trailing: IconButton(
            splashRadius: 15,
            onPressed: _toggleVisibility,
            icon: const Icon(Icons.close),
          ),
        ),
      ),
    );
  }

  ListView generateToDoList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _foundToDoList.length,
      itemBuilder: (context, index) {
        return ToDoItem(
            todo: _foundToDoList[index],
            onToDoChange: _handleToDoChange,
            onDeleteToDo: _deleteToDoItem);
      },
    );
  }
}
