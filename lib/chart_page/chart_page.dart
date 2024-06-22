import 'package:chickychickyplanner/chart_page/chart_function.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                          'Chart',
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
                      Expanded(child: ChartFunction()),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
