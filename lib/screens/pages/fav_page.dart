import 'package:flutter/material.dart';

class EventGridItem extends StatelessWidget {
  final String imagePath;
  final String date;
  final String eventName;
  final String location;
  final String price;

  EventGridItem({
    required this.imagePath,
    required this.date,
    required this.eventName,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 220,
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(imagePath,fit: BoxFit.fill,),
            ),
          ),
          Text(eventName,style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey.shade300,
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(color: Colors.grey.shade300),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 30,
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              price,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff02cad0),
                fontWeight: FontWeight.bold,
              ),
            ),
          )



        ],
      ),
    )
    ;
  }
}

class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        title: const Text("Favourites"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev1.jpg",
                      date: "Event Date 1",
                      eventName: "Event Name 1",
                      location: "Event Location 1",
                      price: "100",
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between items
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev2.jpg",
                      date: "Event Date 2",
                      eventName: "Event Name 2",
                      location: "Event Location 2",
                      price: "150",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev2.jpg",
                      date: "Event Date 1",
                      eventName: "Event Name 1",
                      location: "Event Location 1",
                      price: "100",
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between items
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev1.jpg",
                      date: "Event Date 2",
                      eventName: "Event Name 2",
                      location: "Event Location 2",
                      price: "150",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev1.jpg",
                      date: "Event Date 1",
                      eventName: "Event Name 1",
                      location: "Event Location 1",
                      price: "100",
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between items
                  Expanded(
                    child: EventGridItem(
                      imagePath: "assets/ev2.jpg",
                      date: "Event Date 2",
                      eventName: "Event Name 2",
                      location: "Event Location 2",
                      price: "150",
                    ),
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
