import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class TicketWidget extends StatelessWidget {
  final String imagePath;
  final String eventName;
  final String date;
  final String ticketInfo;

  TicketWidget({
    required this.imagePath,
    required this.eventName,
    required this.date,
    required this.ticketInfo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        padding: EdgeInsets.all(6),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(imagePath, width: 100, height: 100),
              SizedBox(width: 10,),
              Container(
                height: 80,
                width: 1,
                color: Colors.black,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              SizedBox(width: 10,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    ticketInfo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TicketWidget(
                imagePath: "assets/img.png",
                eventName: "Adventure Race",
                date: "20 July, 9 pm",
                ticketInfo: "Ticket: 1",
              ),
              SizedBox(height: 20), // Add some spacing between tickets
              TicketWidget(
                imagePath: "assets/img.png",
                eventName: "Concert",
                date: "25 July, 7 pm",
                ticketInfo: "Ticket: 2",
              ),
              // Add more TicketWidgets as needed
            ],
          ),
        ),
      ),
    );
  }
}
