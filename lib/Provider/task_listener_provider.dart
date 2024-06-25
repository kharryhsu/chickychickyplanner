import 'package:chickychickyplanner/Provider/task_provider.dart';
import 'package:flutter/material.dart';

class TaskListenerProvider with ChangeNotifier {
  TaskProvider taskProvider;

  TaskListenerProvider(this.taskProvider) {
    taskProvider.addListener(promptTextTask);
    promptTextTask();
  }

  List<String> taskList = [];

  void promptTextTaskClear() {
    taskList.clear();
    notifyListeners();
  }

  String promptTextTask() {
    taskList = taskProvider.tasks.map((task) {
      return 'Course: ${task.courseName}, Task name: ${task.title}, Complete: ${task.isDone.toString()}, Deadline: ${task.dueDate == null ? 'No due date chosen' : task.dueDate!.toLocal().toString().split(' ')[0]}';
    }).toList();
    return taskList.join('\n');
  }

  @override
  void dispose() {
    taskProvider.removeListener(promptTextTask);
    super.dispose();
  }
}
