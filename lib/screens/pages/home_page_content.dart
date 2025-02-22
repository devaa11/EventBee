import 'package:event_application1/Controllers/trendingeventController.dart';
import 'package:event_application1/Firebase/event_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package
import '../../widget/PopularEventColumns.dart';
import '../../widget/categories_slider.dart';
import '../../widget/featuredeventslider.dart';
import '../CategorySliderViewAll.dart';
import '../event_details_page.dart';
import '../featuredViewAll.dart';
import '../popularViewAll.dart';

// Create a controller class that extends GetxController
class SearchController extends GetxController {
  final trendingEventController = Get.find<TrendingEventController>();

  // Define an RxString for search query
  var searchQuery = ''.obs;

  // Define a function to filter events by search query
  List<EventData> filterEventsBySearch(String query) {
    return trendingEventController.getAllEvents().where((event) {
      return event.eventName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}

class HomeController extends GetxController {
  // You can define your controller logic and variables here
  var searchHint = "Search events".obs; // Example reactive variable
}

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final TextEditingController _searchController = TextEditingController();

  final HomeController homeController = HomeController(); // Initialize the controller
final TrendingEventController trendingEventController=Get.put(TrendingEventController());
  List<EventData> filteredEvents = [];


  @override
  void initState() {
    super.initState();
    homeController.searchHint.value = "Search events"; // Initialize the search hint
  }

  @override
  void dispose() {
    homeController.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.grey[100],
        title: Image.asset("assets/eventbee.png", height: 80,),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.notification_add_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() {
              // Use Obx to update the search hint reactively
              return TextFormField(
                controller: _searchController,
                  onChanged: (query) {
                  },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                  hintText: homeController.searchHint.value, // Use the controller's value
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff02cad0), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              width: constraints.maxWidth,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Featured Events",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all featured events page
                            Get.to(FeaturedViewAll());
                          },
                          child: const Text("View All"),
                        ),
                      ],
                    ),
                  ),
                  FeaturedEventsSlider(),
                  SizedBox(height: 10), // Adjust this SizedBox to control the gap

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trending Events",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(CategorySliderViewAll());
                          },
                          child: const Text("View All"),
                        ),
                      ],
                    ),
                  ),
                  categoryslider(),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Popular Events",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all popular events page
                            Get.to(PopularViewAll());
                          },
                          child: const Text("View All"),
                        ),
                      ],
                    ),
                  ),
                  PopularEvents(),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
