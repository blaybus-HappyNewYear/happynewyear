import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex; // 초기 인덱스

  BottomNavigation({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // int _selectedIndex = 0;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // 초기 값 설정
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/mainpage');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/questpage');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/xppage');
        break;
      case 3:
        Navigator.pushReplacementNamed(
          context,
          '/boardpage',
          arguments: {'isAdmin': true},
        );
        break;

        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/mypage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Image.asset("assets/icons/home_unselect.png"),
    activeIcon: Image.asset("assets/icons/home_select.png"), label: ''),
    BottomNavigationBarItem(icon: Image.asset("assets/icons/quest_unselect.png"),
    activeIcon: Image.asset("assets/icons/quest_select.png"), label: ''),
    BottomNavigationBarItem(icon: Image.asset("assets/icons/xp_unselect.png"),
    activeIcon: Image.asset("assets/icons/xp_select.png"), label: ''),
    BottomNavigationBarItem(icon: Image.asset("assets/icons/noticeboard_unselect.png"),
    activeIcon: Image.asset("assets/icons/noticeboard_select.png"), label: ''),
    BottomNavigationBarItem(icon: Image.asset("assets/icons/my_unselect.png"),
    activeIcon: Image.asset("assets/icons/my_select.png"), label: ''),
    ],
      // items: items,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}