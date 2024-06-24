import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chickychickyplanner/Model/task.dart';
import 'package:chickychickyplanner/Provider/course_provider.dart';
import 'package:chickychickyplanner/Provider/task_provider.dart';

class ChecklistFunction extends StatefulWidget {
  const ChecklistFunction({super.key});

  @override
  State<ChecklistFunction> createState() => _ChecklistFunctionState();
}

class _ChecklistFunctionState extends State<ChecklistFunction> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  Task? _editedTask;

  void addTaskInfo(BuildContext context, String courseId, String courseName) {
    final taskText = _taskController.text;
    if (taskText.isNotEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final taskId =
          _editedTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      if (_editedTask == null) {
        taskProvider.addTask(
          Task(
            title: taskText,
            isDone: false,
            id: taskId,
            courseId: courseId,
            courseName: courseName,
            dueDate: _selectedDate,
          ),
        );
      } else {
        taskProvider.editTask(_editedTask!, taskText, _selectedDate);
        _editedTask = null;
      }

      _taskController.clear();
      _selectedDate = null;
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Name'),
            content: const Text('Please enter a task name.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void addTaskDialog(String courseId, String courseName, [Task? taskToEdit]) {
    if (taskToEdit != null) {
      _taskController.text = taskToEdit.title;
      _selectedDate = taskToEdit.dueDate;
      _editedTask = taskToEdit;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(_editedTask == null ? 'New Task' : 'Edit Task',style: TextStyle(
                color: Color(0xffcc29aa),
                fontWeight: FontWeight.bold,),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Task'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'No due date chosen'
                          : 'Due Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',style: TextStyle(fontSize: 12
                          ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _taskController.clear();
                    _selectedDate = null;
                    _editedTask = null;
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    addTaskInfo(
                      context,
                      courseId,
                      courseName,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CourseProvider, TaskProvider>(
      builder: (context, courseProvider, taskProvider, _) {
        return ListView.builder(
          itemCount: courseProvider.courseId.length,
          itemBuilder: (context, index) {
            final courseId = courseProvider.courseId[index];
            final courseName = courseProvider.coursename[index];
            final courseTaskItems =
                taskProvider.getTaskItemsForCourse(courseId);

            return Card(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              color: const Color.fromARGB(255, 255, 252, 247),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromARGB(255, 76, 46, 2),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courseTaskItems.length,
                    itemBuilder: (ctx, taskIndex) {
                      final item = courseTaskItems[taskIndex];
                      return Dismissible(
                        key: Key(item.id),
                        onDismissed: (direction) {
                          taskProvider.removeTask(item);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: item.isDone
                                    ? const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      )
                                    : const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                      ),
                                child: Text(item.title),
                              ),
                              if (item.dueDate != null)
                                Text(
                                  'Due: ${item.dueDate!.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                          leading: Checkbox(
                            value: item.isDone,
                            onChanged: (value) {
                              taskProvider.checkBox(value!, item);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              addTaskDialog(courseId, courseName, item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => addTaskDialog(courseId, courseName),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 252, 247),
                        backgroundColor: const Color.fromARGB(255, 76, 46, 2),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
