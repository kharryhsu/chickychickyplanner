import 'package:chickychickyplanner/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 700,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("lib/images/Decorations/Start_background.jpg"),
                fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First",
                        style: GoogleFonts.lemon(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          height: -0.1,
                          color: const Color(0xffC88421),
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Text(
                        "Time",
                        style: GoogleFonts.lemon(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          height: -0.1,
                          color: const Color(0xffC88421),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Using ?",
                        style: GoogleFonts.lemon(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          height: -0.1,
                          color: const Color(0xffC88421),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            MyApp.navigatorKey.currentState!
                                .pushNamed('/tutorial');
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 250, 243, 243),
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 250, 243, 243),
                                width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text("Started Tutorial"),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: TextButton(
                          onPressed: () {
                            MyApp.navigatorKey.currentState!
                                .pushNamed('/table');
                          },
                          child: const Text(
                            "Skip Tutorial",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffC88421),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 350,
                width: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "lib/images/Decorations/ChickyChicky.png"),
                        fit: BoxFit.fill)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
