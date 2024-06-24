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
    if (_currentPage < 5) {
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
            top: 40,
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
    for (int i = 0; i < 6; i++) {
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
