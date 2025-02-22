import 'package:get/get.dart';
import 'package:event_application1/Firebase/event_data.dart';
import 'package:event_application1/Firebase/services.dart';

class PopularEventsController extends GetxController {
  RxList<EventData> events = <EventData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final eventList = await EventService.fetchEvents();
    events.assignAll(eventList);
  }
  void removeEventById(String eventId) {
    events.removeWhere((event) => event.eventId == eventId);
  }

}
