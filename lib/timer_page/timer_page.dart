import 'package:chickychickyplanner/Model/character_information.dart';
import 'package:chickychickyplanner/Model/collections.dart';
import 'package:chickychickyplanner/Provider/collections_provider.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:chickychickyplanner/Provider/course_provider.dart';
import 'package:chickychickyplanner/Provider/timer_provider.dart';
import 'package:chickychickyplanner/timer_page/timer_button.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    super.key,
  });

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  bool valid = false;

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  void previousImage(TimerProvider timerProvider) {
    setState(() {
      timerProvider.updateCurrentImageIndex(
        (timerProvider.currentImageIndex -
                1 +
                images[timerProvider.currentImageLevel].length) %
            images[timerProvider.currentImageLevel].length,
      );
    });
  }

  void nextImage(TimerProvider timerProvider) {
    setState(() {
      timerProvider.updateCurrentImageIndex(
        (timerProvider.currentImageIndex + 1) %
            images[timerProvider.currentImageLevel].length,
      );
    });
  }

  void setCustomTime(TimerProvider timerProvider) {
    int hours = int.tryParse(hoursController.text) ?? 0;
    int minutes = int.tryParse(minutesController.text) ?? 0;
    if ((hours * 3600) + (minutes * 60) != 0) {
      setState(() {
        timerProvider.maxSeconds = (hours * 3600) + (minutes * 60);
        timerProvider.seconds = (hours * 3600) + (minutes * 60);
        valid = true;
      });
    } else {
      setState(() {
        valid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        return Consumer<TimerProvider>(
          builder: (context, timerProvider, _) {
            return Consumer<ItemCollectionProvider>(
              builder: (context, itemCollectionProvider, _) {
                List<String> courses = courseProvider.coursename;
                bool coursesAvailable = courses.isNotEmpty;
                timerProvider.onTimerFinish = () {
                  String obtainedOnFormatted =
                      DateFormat('MM/dd/yyyy, hh:mm a').format(DateTime.now());
                  int hours;
                  int minutes;
                  hours = timerProvider.maxSeconds ~/ 3600;
                  minutes = (timerProvider.maxSeconds ~/ 60) % 60;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Congratulations!'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.asset(
                                images[timerProvider.currentImageLevel]
                                    [timerProvider.currentImageIndex],
                                width: 150,
                                height: 150,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'You got a/an ${name[timerProvider.currentImageIndex]}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              itemCollectionProvider.addItemCollections(ItemCollection(
                                  courseId: courseProvider.courseId[
                                      courseProvider.coursename.indexOf(
                                          timerProvider.selectedCourse ?? "")],
                                  image: images[timerProvider.currentImageLevel]
                                      [timerProvider.currentImageIndex],
                                  name: name[timerProvider.currentImageIndex],
                                  duration:
                                      '$hours hour ${minutes.toString().padLeft(2, '0')} minute',
                                  obtainedOn: obtainedOnFormatted,
                                  rarity:
                                      rarity[timerProvider.currentImageLevel]));
                              timerProvider.selectedCourse = null;
                              timerProvider.updateCurrentImageLevel(0);
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                };
                return Center(
                  child: Listener(
                    onPointerMove: (moveEvent) {
                      double sensitivity = 18;
                      if (moveEvent.delta.dx > sensitivity) {
                        previousImage(timerProvider);
                      } else if (moveEvent.delta.dx < -sensitivity) {
                        nextImage(timerProvider);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCharacter(timerProvider),
                        const SizedBox(
                          height: 20,
                        ),
                        buildCourseDropdownMenu(timerProvider, courses),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Visibility(
                                visible: !timerProvider.hasStarted,
                                child: buildCharacterInputFields()),
                            Visibility(
                                visible: timerProvider.hasStarted,
                                child: buildTime(timerProvider)),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildButton(timerProvider, coursesAvailable),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildButton(TimerProvider timerProvider, bool coursesAvailable) {
    final isRunning = timerProvider.timer?.isActive ?? false;
    final bool isFinished = timerProvider.seconds == 0;

    if (!coursesAvailable ||
        isFinished ||
        timerProvider.selectedCourse == null) {
      return ButtonWidget(
        text: 'Start',
        color: Colors.grey,
        background: Colors.grey[300]!,
        onClicked: () {},
      );
    }

    if (isRunning) {
      return ButtonWidget(
        text: 'Cancel',
        color: Colors.white,
        background: const Color.fromARGB(255, 76, 46, 2),
        onClicked: () {
          timerProvider.stopTimer();
        },
      );
    } else {
      return ButtonWidget(
        text: 'Start',
        color: Colors.white,
        background: const Color.fromARGB(255, 76, 46, 2),
        onClicked: () {
          setCustomTime(timerProvider);
          if (valid) {
            timerProvider.startTimer();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Invalid Time'),
                  content: const Text(
                      'Please enter a valid duration for the timer.'),
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
        },
      );
    }
  }

  Widget buildCourseDropdownMenu(
      TimerProvider timerProvider, List<String> courses) {
    return DropdownButton<String>(
      hint: const Text('Course'),
      value: timerProvider.selectedCourse,
      items: courses.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          timerProvider.selectedCourse = newValue;
        });
      },
    );
  }

  Widget buildCharacterInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: TextField(
            controller: hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hours',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: TextField(
            controller: minutesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCharacter(TimerProvider timerProvider) {
    int timeIndicator = timerProvider.maxSeconds - timerProvider.seconds;

    if (timeIndicator > 0 && timeIndicator < 3600) {
      timerProvider.currentImageLevel = 0;
    } else if (timeIndicator >= 3600 && timeIndicator < 7200) {
      timerProvider.currentImageLevel = 1;
    } else if (timeIndicator >= 7200 && timeIndicator < 10800) {
      timerProvider.currentImageLevel = 2;
    } else if (timeIndicator >= 10800 && timeIndicator < 14400) {
      timerProvider.currentImageLevel = 3;
    } else if (timeIndicator >= 14400 && timeIndicator < 18000) {
      timerProvider.currentImageLevel = 4;
    } else if (timeIndicator >= 18000) {
      timerProvider.currentImageLevel = 5;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: CircularProgressIndicator(
            value: timerProvider.seconds / timerProvider.maxSeconds,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 76, 46, 2),
            ),
            strokeWidth: 10,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !timerProvider.hasStarted,
              child: IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () => previousImage(timerProvider),
              ),
            ),
            Image.asset(
              images[timerProvider.currentImageLevel]
                  [timerProvider.currentImageIndex],
              width: 200,
              height: 350,
            ),
            Visibility(
              visible: !timerProvider.hasStarted,
              child: IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () => nextImage(timerProvider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTime(TimerProvider timerProvider) {
    int hours;
    int minutes;
    int remainingSeconds;
    if (timerProvider.seconds > 0) {
      hours = timerProvider.seconds ~/ 3600;
      minutes = (timerProvider.seconds ~/ 60) % 60;
      remainingSeconds = timerProvider.seconds % 60;
    } else {
      hours = 0;
      minutes = 0;
      remainingSeconds = 0;
    }
    return Text(
      '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 76, 46, 2),
        fontSize: 50,
      ),
    );
  }
}
