import 'package:chickychickyplanner/table_page/table_overview.dart';
import 'package:chickychickyplanner/table_page/table_list.dart';
import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/images/Main.png',
            fit: BoxFit.fill,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 16),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 252, 247),
                  border: Border.all(
                    color: const Color.fromARGB(255, 76, 46, 2),
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(150),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = 0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Lists",
                            style: TextStyle(
                              fontSize: current == 0 ? 16 : 14,
                              fontWeight: FontWeight.bold,
                              decoration: current == 0
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationColor:
                                  const Color.fromARGB(255, 186, 112, 0),
                              color: current == 0
                                  ? const Color.fromARGB(255, 186, 112, 0)
                                  : const Color.fromARGB(255, 76, 46, 2),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            "Overview",
                            style: TextStyle(
                              fontSize: current == 1 ? 16 : 14,
                              fontWeight: FontWeight.bold,
                              decoration: current == 1
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationColor:
                                  const Color.fromARGB(255, 186, 112, 0),
                              color: current == 1
                                  ? const Color.fromARGB(255, 186, 112, 0)
                                  : const Color.fromARGB(255, 76, 46, 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: current,
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
                    child: const ListTab(),
                  ),
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: OverviewTab(),
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
