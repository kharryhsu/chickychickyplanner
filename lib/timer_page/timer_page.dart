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
  FocusNode hoursFocusNode = FocusNode();
  FocusNode minutesFocusNode = FocusNode();
  ValueNotifier<bool> dropdownVisible = ValueNotifier<bool>(true);
  bool valid = false;
  bool isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    hoursFocusNode.addListener(onFocusChange);
    minutesFocusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    hoursFocusNode.dispose();
    minutesFocusNode.dispose();
    dropdownVisible.dispose();
    super.dispose();
  }

  void onFocusChange() {
    if (!hoursFocusNode.hasFocus &&
        !minutesFocusNode.hasFocus &&
        !isKeyboardOpen) {
      _delayedVisibility(true);
    } else {
      _delayedVisibility(false);
    }
  }

  void _delayedVisibility(bool visible) {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        dropdownVisible.value = visible;
      });
    });
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
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 30.0, top: 20),
                              child: Text('Congratulations!',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff12651b))),
                            ),
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
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Text(
                                timerProvider.currentImageIndex != 3
                                    ? 'You got a ${name[timerProvider.currentImageIndex]}'
                                    : 'You got an ${name[timerProvider.currentImageIndex]}',
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
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 900,
                          width: 450,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/images/Timer.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Column(
                            children: [
                              buildCharacter(timerProvider),
                              buildFadeInWidget(
                                isVisible: dropdownVisible.value,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    buildCourseDropdownMenu(
                                        timerProvider, courses),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
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
                              buildFadeInWidget(
                                isVisible: dropdownVisible.value,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    buildButton(
                                        timerProvider, coursesAvailable),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              )
                            ],
                          ),
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
                  title: const Text(
                    'Invalid Time',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff12651b)),
                  ),
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
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xff68534d), width: 3),
      ),
      child: DropdownButton<String>(
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
        dropdownColor: Colors.white,
        underline: const SizedBox(),
        isExpanded: true,
      ),
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
            focusNode: hoursFocusNode,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hours',
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: TextField(
            controller: minutesController,
            focusNode: minutesFocusNode,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCharacter(TimerProvider timerProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: timerProvider.seconds / timerProvider.maxSeconds,
            backgroundColor: const Color(0xff12651b),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 255, 255, 255),
            ),
            strokeWidth: 20,
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
              width: 150,
              height: 150,
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
        color: Color(0xff12651b),
        fontSize: 45,
      ),
    );
  }

  Widget buildFadeInWidget({required bool isVisible, required Widget child}) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: isVisible == true
          ? const Duration(milliseconds: 1000)
          : const Duration(milliseconds: 0),
      curve: Curves.easeIn,
      child: Visibility(
        visible: isVisible,
        child: child,
      ),
    );
  }
}
