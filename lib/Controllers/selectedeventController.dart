import 'package:get/get.dart';
import 'package:event_application1/Firebase/event_data.dart';

class SelectedEventController extends GetxController {
  Rx<EventData?> selectedEvent = Rx<EventData?>(null);

  void selectEvent(EventData event) {
    selectedEvent.value = event;
  }
}
