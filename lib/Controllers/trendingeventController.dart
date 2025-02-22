import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Firebase/event_data.dart';
import '../Firebase/services.dart';

class TrendingEventController extends GetxController {
  final RxList<EventData> events = <EventData>[].obs; // Observable list of events

  @override
  void onInit() async {
    super.onInit();
    await fetchEvents(); // Fetch events when the controller is initialized
  }

  Future<void> fetchEvents() async {
    final eventList = await EventService.fetchEventsSortedByTimestamp(); // Fetch events sorted by timestamp
    events.assignAll(eventList);
  }
  List<EventData> getAllEvents() {
    return events.toList();
  }
  List<EventData> filteredEvents(int selectedCategoryIndex, List<Map<String, dynamic>> categories) {
    if (selectedCategoryIndex == 0) {
      return events.toList(); // Show all events for index 0 (All)
    } else {
      final category = categories[selectedCategoryIndex]["name"];
      return events.where((event) => event.category == category).toList();
    }
  }
  void removeEventById(String eventId) {
    events.removeWhere((event) => event.eventId == eventId);
  }

}
