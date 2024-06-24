import 'package:chickychickyplanner/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
                        "Get Better",
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
                        "Study with",
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
                        "Chicky",
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
                        "Chicky",
                        style: GoogleFonts.lemon(
                          fontSize: 46,
                          height: -0.1,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffC88421),
                        ),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            MyApp.navigatorKey.currentState!
                                .pushNamed('/options');
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
                            child: Text("Get Started"),
                          ))
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
