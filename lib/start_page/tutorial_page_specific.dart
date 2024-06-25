import 'package:flutter/material.dart';

class TutorialPageSpecific extends StatefulWidget {
  final int currentPage;

  const TutorialPageSpecific({required this.currentPage, super.key});

  @override
  TutorialPageSpecificState createState() => TutorialPageSpecificState();
}

class TutorialPageSpecificState extends State<TutorialPageSpecific> {
  final PageController _pageController = PageController();
  late int _currentPage;
  late List<String> tutorialImages;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
    tutorialImages = getTutorialImagesForPage(_currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _goToNextPage() {
    if (_pageController.page! < tutorialImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  List<String> getTutorialImagesForPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return [
          'lib/images/Tutorial_page/Tutorial_page_00.png',
          'lib/images/Tutorial_page/Tutorial_page_01.png',
        ];
      case 1:
        return [
          'lib/images/Tutorial_page/Tutorial_page_02.png',
        ];
      case 2:
        return [
          'lib/images/Tutorial_page/Tutorial_page_03.png',
        ];
      case 3:
        return [
          'lib/images/Tutorial_page/Tutorial_page_04.png',
        ];
      case 4:
        return [
          'lib/images/Tutorial_page/Tutorial_page_05.png',
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSinglePage = tutorialImages.length == 1;

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
              for (String imagePath in tutorialImages)
                _buildTutorialPage(imagePath),
            ],
          ),
          if (isSinglePage)
            Positioned(
              top: 20,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 40,
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          else
            Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 40,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
        ],
      ),
    );
  }

  List<Widget> _buildIndicatorDots() {
    List<Widget> dots = [];
    for (int i = 0; i < tutorialImages.length; i++) {
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
}
