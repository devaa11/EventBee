import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/trendingeventController.dart';
import '../screens/event_details_page.dart';

class TrendingEventsSlider extends StatelessWidget {
  final int selectedCategoryIndex;
  final List<Map<String, dynamic>> categories;

  TrendingEventsSlider({
    required this.selectedCategoryIndex,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final trendingEventController = Get.put(TrendingEventController());
        final events =
        trendingEventController.filteredEvents(selectedCategoryIndex, categories);

        return CarouselSlider(
          items: events.map(
                (event) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 10, right: 10),
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
                      bottom: -4,
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
          carouselController: CarouselController(),
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlay: false,
            enableInfiniteScroll: false,
          ),
        );
      },
    );
  }
}
