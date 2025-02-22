import 'package:event_application1/screens/publishedEventDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/YourPublishedEventsController.dart';
import '../screens/event_details_page.dart';

class YourPublishedEvents extends StatefulWidget {
  @override
  State<YourPublishedEvents> createState() => _YourPublishedEventsState();
}

class _YourPublishedEventsState extends State<YourPublishedEvents> {
  final YourPublishedEventsController yourPublishedEventsController =
  Get.put(YourPublishedEventsController()); // Use your controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Your Created Events"),
      ),
      body: Obx(() {
        final events = yourPublishedEventsController.events;

        if (events.isEmpty) {
          return Center(
            child: Text("You haven't published anything yet."),
          );
        }

        return Container(
          child: Column(
            children: events.map((event) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[100],
                            image: event.imagepath.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(event.imagepath),
                              // Use NetworkImage for network URLs
                              fit: BoxFit.cover,
                            )
                                : null, // Handle empty or invalid URLs
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(PublishedEventDetails(event: event));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event.eventName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    event.date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        width: 50,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          event.price,
                          style: TextStyle(
                            color: Color(0xff02cad0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
