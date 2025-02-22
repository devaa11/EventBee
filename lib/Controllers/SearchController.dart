import 'package:event_application1/Firebase/event_data.dart';
import 'package:get/get.dart';
import '../Controllers/trendingeventController.dart'; // Import your existing event controller

class SearchController extends GetxController {
  final TrendingEventController trendingEventController = Get.find<TrendingEventController>();

  // Define an RxString for search query
  var searchQuery = ''.obs;

  // Define a function to filter events by search query
  List<EventData> filterEventsBySearch(String query) {
    return trendingEventController.getAllEvents().where((event) {
      return event.eventName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Define the updateSearchQuery function
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
