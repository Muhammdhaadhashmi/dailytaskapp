
import 'package:dailytaskapp/db/repository.dart';
import 'package:dailytaskapp/models/todo.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  saveTodos(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  readTodos() async {
    return await _repository.readData('todos');
  }

  readTodosByCategory(category)async{
    return await _repository.readDataByColumnName('todos', 'category', category);

  }
}