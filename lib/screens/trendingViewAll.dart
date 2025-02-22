import 'package:event_application1/Firebase/event_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/trendingeventController.dart';
import '../screens/event_details_page.dart';



class TrendingViewAll extends StatelessWidget {
  final int selectedCategoryIndex;
  final List<Map<String, dynamic>> categories;

  TrendingViewAll({
    required this.selectedCategoryIndex,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final trendingEventController = Get.put(TrendingEventController());

    return Obx(() {
      final events =
      trendingEventController.filteredEvents(selectedCategoryIndex, categories);

      return ListView(
        children: events.map(
              (event) {
            return Container(
              height: MediaQuery.of(context).size.height*0.29,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
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
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.location,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                Get.to(EventDetailsPage(event: event));
                              },
                              child: Container(
                                height: 35,
                                width: 90,
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
                                    "Join",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      );
    });
  }
}
