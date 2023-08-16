import 'package:flutter/material.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/models/todo.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final onToDoChange;
  final onDeleteToDo;
  const ToDoItem(
      {super.key, required this.todo, this.onToDoChange, this.onDeleteToDo});

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  double marginText = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
          title: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            margin: EdgeInsets.only(left: marginText),
            child: Text(
              widget.todo.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.todo.isDone ? Colors.grey : Colors.black,
                decoration:
                    widget.todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          leading: Checkbox(
            value: widget.todo.isDone,
            onChanged: (value) {
              setState(() {
                widget.onToDoChange(widget.todo);
                marginText = 5;
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    marginText = 0;
                  });
                });
              });
            },
          ),
          trailing: IconButton(
            splashRadius: 16,
            onPressed: () {
              setState(() {
                widget.onDeleteToDo(widget.todo);
              });
            },
            icon: const Icon(
              Icons.delete,
              color: red,
            ),
          )),
    );
  }
}
