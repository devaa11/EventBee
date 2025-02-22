import 'package:event_application1/Firebase/event_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/featuredEventController.dart';
import '../screens/event_details_page.dart';

class FeaturedEventsSlider extends StatelessWidget {
  final FeaturedEventsController _eventController =
  Get.put(FeaturedEventsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: Obx(
            () {
          final events = _eventController.events;

          return ListView(
            scrollDirection: Axis.horizontal,
            children: events.map((event) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[100],
                        image: event.imagepath.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(event.imagepath),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            event.eventName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                event.location,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Get.to(EventDetailsPage(event: event));
                            },
                            child: Container(
                              height: 30,
                              width: 85,
                              decoration: BoxDecoration(
                                color: const Color(0xff02cad0),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xff02cad0),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
