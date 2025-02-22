import 'package:event_application1/Firebase/event_data.dart';
import 'package:event_application1/Firebase/services.dart';
import 'package:get/get.dart';

class FeaturedEventsController extends GetxController {
  final RxList<EventData> events = <EventData>[].obs; // Observable list of events

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final eventList = await EventService.fetchEvents();
    events.assignAll(eventList);
  }

  // Add this method to remove an event by ID
  void removeEventById(String eventId) {
    events.removeWhere((event) => event.eventId == eventId);
  }
}
