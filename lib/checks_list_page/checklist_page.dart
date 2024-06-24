import 'package:chickychickyplanner/checks_list_page/checklist_function.dart';
import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/images/Todo.png',
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 161),
            Expanded(
              child: IndexedStack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 252, 247),
                      border: Border(
                        top: BorderSide(
                          color: Color.fromARGB(255, 76, 46, 2),
                          width: 2.0,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 13, 0, 0),
                          child: Text(
                            'Todolist',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Divider(
                            thickness: 2,
                            color: Color.fromARGB(255, 76, 46, 2),
                          ),
                        ),
                        Expanded(child: ChecklistFunction()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
