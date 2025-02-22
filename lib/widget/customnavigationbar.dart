import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onIndexChanged,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Color(0xff02cad0),
          icon: Icon(Icons.home,color: Colors.black,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xff02cad0),
          icon: Icon(Icons.favorite,color: Colors.black,),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xff02cad0),
          icon: Icon(Icons.airplane_ticket,color: Colors.black,),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xff02cad0),
          icon: Icon(Icons.person,color: Colors.black,),
          label: 'Profile',
        ),
      ],
    );
  }
}
