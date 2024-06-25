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
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToNextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      MyApp.navigatorKey.currentState!.pushNamed('/table');
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
              for (int i = 0; i < 6; i++)
                _buildTutorialPage(
                    'lib/images/Tutorial_page/Tutorial_page_0$i.png'),
              _buildLastTutorialPage('lib/images/Decorations/ChickyChicky.png'),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              color: Colors.white.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _goToPreviousPage,
                    color: const Color.fromARGB(255, 76, 46, 2),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildIndicatorDots(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: _goToNextPage,
                    color: const Color.fromARGB(255, 76, 46, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicatorDots() {
    List<Widget> dots = [];
    for (int i = 0; i < 7; i++) {
      dots.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? const Color.fromARGB(255, 241, 192, 31)
                : const Color.fromARGB(255, 167, 167, 167),
          ),
        ),
      );
    }
    return dots;
  }

  Widget _buildTutorialPage(String imageName) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        int sensitivity = 20;
        if (details.delta.dx > sensitivity) {
          _goToPreviousPage();
        } else if (details.delta.dx < -sensitivity) {
          _goToNextPage();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageName),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLastTutorialPage(String imageName) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        int sensitivity = 20;
        if (details.delta.dx > sensitivity) {
          _goToPreviousPage();
        } else if (details.delta.dx < -sensitivity) {
          _goToNextPage();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageName),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
