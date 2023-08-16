class ToDo {
  String? id;
  String? description;
  bool isDone;

  ToDo({
    this.id,
    this.description,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(
        id: '1',
        description: 'Buy milk',
      ),
    ];
  }
}
