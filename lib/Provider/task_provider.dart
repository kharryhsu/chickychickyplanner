import 'package:chickychickyplanner/Model/task.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void checkBox(bool value, Task task) {
    task.isDone = value;
    notifyListeners();
  }

  void editTask(Task task, String newTitle, DateTime? selectedDate) {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      _tasks[taskIndex].title = newTitle;
      _tasks[taskIndex].dueDate = selectedDate;
      notifyListeners();
    }
  }

  List<Task> getTaskItemsForCourse(String id) {
    return _tasks.where((item) => item.courseId == id).toList();
  }

  List<String> taskList = [];

  String promptTextTask() {
    taskList = _tasks.map((task) {
      return 'Course: ${task.courseName}, Task name: ${task.title}, Complete: ${task.isDone.toString()}, Deadline: ${task.dueDate == null ? 'No due date chosen' : task.dueDate!.toLocal().toString().split(' ')[0]}';
    }).toList();
    return taskList.join('\n');
  }

  void promptTextTaskClear() {
    taskList.clear();
  }
}
