import 'package:chickychickyplanner/main.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  TutorialPageState createState() => TutorialPageState();
}

class TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildTutorialPage('Page 1', Colors.blue),
              _buildTutorialPage('Page 2', Colors.green),
              _buildTutorialPage('Page 3', Colors.orange),
              _buildLastTutorialPage('Page 4', Colors.purple),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _goToPreviousPage,
                  color: Colors.black,
                ),
                const SizedBox(width: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildIndicatorDots(),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _goToNextPage,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicatorDots() {
    List<Widget> dots = [];
    for (int i = 0; i < 4; i++) {
      dots.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? const Color.fromARGB(255, 76, 46, 2)
                : Colors.grey,
          ),
        ),
      );
    }
    return dots;
  }

  Widget _buildTutorialPage(String text, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLastTutorialPage(String text, Color color) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              MyApp.navigatorKey.currentState!.pushNamed('/table');
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
