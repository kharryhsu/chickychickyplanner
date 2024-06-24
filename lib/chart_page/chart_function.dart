import 'package:chickychickyplanner/Model/collections.dart';
import 'package:chickychickyplanner/Provider/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chickychickyplanner/Provider/course_provider.dart';

class ChartFunction extends StatefulWidget {
  const ChartFunction({super.key});

  @override
  _ChartFunctionState createState() => _ChartFunctionState();
}

class _ChartFunctionState extends State<ChartFunction> {
  ItemCollection? selectedItem;

  void selectItem(ItemCollection item) {
    setState(() {
      selectedItem = item;
    });
  }

  void clearSelectedItem() {
    setState(() {
      selectedItem = null;
    });
  }

  final Map<String, TextStyle> rarityTextStyles = {
    'Common': const TextStyle(color: Colors.grey),
    'Rare': const TextStyle(color: Colors.blue),
    'Epic': const TextStyle(color: Colors.purple),
    'Legendary': const TextStyle(color: Colors.red),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        return Consumer<ItemCollectionProvider>(
          builder: (context, itemCollectionProvider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: courseProvider.courseId.length,
                      itemBuilder: (context, index) {
                        final courseId = courseProvider.courseId[index];
                        final courseName = courseProvider.coursename[index];
                        final courseCollectionItems = itemCollectionProvider
                            .getItemCollectionForCourse(courseId);
                        var itemMap = <String, List<ItemCollection>>{};
                        for (var item in courseCollectionItems) {
                          if (itemMap.containsKey(item.image)) {
                            itemMap[item.image]!.add(item);
                          } else {
                            itemMap[item.image] = [item];
                          }
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Wrap(
                              spacing: 20.0,
                              runSpacing: 10.0,
                              children: itemMap.entries.map((entry) {
                                var items = entry.value;
                                var itemCount = items.length;
                                var mainItem = items.last;

                                return GestureDetector(
                                  onTap: () => selectItem(mainItem),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Image.asset(
                                          mainItem.image,
                                          width: 70,
                                          height: 70,
                                        ),
                                      ),
                                      if (itemCount > 1)
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 24,
                                              minHeight: 24,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$itemCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(
                              thickness: 2,
                              color: Color.fromARGB(255, 76, 46, 2),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (selectedItem != null)
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 76, 46, 2),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${selectedItem!.name}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Duration Obtained: ${selectedItem!.duration}',
                              ),
                              Text(
                                'Obtained On: ${selectedItem!.obtainedOn}',
                              ),
                              Text(
                                'Rarity: ${selectedItem!.rarity}',
                                style: rarityTextStyles[selectedItem!.rarity] ??
                                    const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                clearSelectedItem();
                              },
                            ),
                          ),
                        ),
                      ],
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
