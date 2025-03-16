import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: '뉴스',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny),
          label: '날씨',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'MY',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
} 