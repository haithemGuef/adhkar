import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

enum AdhkarType { morning, evening }

class AdhkarViewer extends StatefulWidget {
  final AdhkarType type;
  final Color backgroundColor;

  const AdhkarViewer({
    super.key,
    required this.type,
    required this.backgroundColor,
  });

  @override
  State<AdhkarViewer> createState() => _AdhkarViewerState();
}

class _AdhkarViewerState extends State<AdhkarViewer> {
  late final PageController _pageController;
  int currentIndex = 0;

  int get maxCount => widget.type == AdhkarType.morning ? 10 : 9;

  String imagePathForIndex(int index) {
    final prefix = widget.type == AdhkarType.morning ? 'Morning' : 'Evening';
    return 'assets/adhkar/Adhkar_${prefix}${index + 1}.jpg';
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToPage(int index) {
    if (index >= 0 && index < maxCount) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: maxCount,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return PhotoView(
                imageProvider: AssetImage(imagePathForIndex(index)),
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 6 : 12, horizontal: 8),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  if (currentIndex > 0)
                    ElevatedButton.icon(
                      onPressed: () => goToPage(currentIndex - 1),
                      // icon: const Icon(Icons.arrow_back),
                      label: Text(
                        "السابق",
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (currentIndex < maxCount - 1)
                    ElevatedButton.icon(
                      onPressed: () => goToPage(currentIndex + 1),
                      // icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        "التالي",
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.backgroundColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              FittedBox(
                child: Text(
                  'الصفحة ${currentIndex + 1} من $maxCount',
                  style: TextStyle(
                    color: widget.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}