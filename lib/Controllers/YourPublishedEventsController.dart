import 'package:get/get.dart';
import 'package:event_application1/Firebase/event_data.dart';
import 'package:event_application1/Firebase/services.dart';

class YourPublishedEventsController extends GetxController {
  RxList<EventData> events = <EventData>[].obs;
  FirestoreService firestoreService = FirestoreService(); // Create an instance

  @override
  void onInit() {
    super.onInit();
    fetchEventsCreatedByUser();
  }

  Future<void> fetchEventsCreatedByUser() async {
    try {
      // Assume FirestoreService is used to interact with Firestore
      final eventList = await firestoreService.fetchEventsCreatedByUser();

      // Update the events list with the fetched events
      events.assignAll(eventList);

    } catch (e) {
      print('Error fetching events created by user: $e');
    }
  }
}
