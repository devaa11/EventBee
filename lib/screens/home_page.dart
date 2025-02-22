import 'package:event_application1/screens/pages/createEventPage.dart';
import 'package:event_application1/screens/pages/fav_page.dart';
import 'package:event_application1/screens/pages/profile_page.dart';
import 'package:event_application1/screens/pages/ticket_page.dart';
import 'package:flutter/material.dart';

// Import your controller if needed
import 'pages/home_page_content.dart';



class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentIndex = 0; // Track the current page index

  final List<Widget> pages = [
    HomePageContent(),
    FavPage(),
    CreateEventPage(),
    TicketPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (currentIndex != 0) {
          setState(() {
            // Navigate back to HomePageContent
            currentIndex = 0;
          });
          return false; // Do not exit the app
        } else {
          // Show exit confirmation dialog
          return showExitConfirmationDialog(context);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildIconButton(Icons.home, 0),
              buildIconButton(Icons.favorite_border, 1),
              buildIconButton(Icons.add, 2),
              buildIconButton(Icons.airplane_ticket, 3),
              buildIconButton(Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton(IconData iconData, int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          currentIndex = index; // Update the current page index
        });
      },
      icon: Icon(
        iconData,
        color: currentIndex == index ? const Color(0xff02cad0) : Colors.black,
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App?'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel exit
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm exit
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );

    return result ?? false; // Default to false if dialog is dismissed
  }
}

