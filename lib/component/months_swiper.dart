import 'package:flutter/material.dart';

class MonthContainer extends StatefulWidget {
  const MonthContainer({Key? key}) : super(key: key);

  @override
  _MonthContainerState createState() => _MonthContainerState();
}

class _MonthContainerState extends State<MonthContainer> {
  late PageController _pageController;
  int _currentPageIndex = DateTime.now().month - 1;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.green,
          ),
          width: 140,
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemCount: _months.length,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  _months[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
