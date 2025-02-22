import 'package:event_application1/Controllers/popularEvetController.dart';
import 'package:event_application1/Controllers/trendingeventController.dart';
import 'package:event_application1/Firebase/event_data.dart';
import 'package:event_application1/Firebase/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/featuredEventController.dart';
import '../Models/UserData.dart';

class PublishedEventDetails extends StatefulWidget {
  final EventData event;

  const PublishedEventDetails({Key? key, required this.event}) : super(key: key);

  @override
  State<PublishedEventDetails> createState() => _PublishedEventDetailsState();
}

class _PublishedEventDetailsState extends State<PublishedEventDetails> {
  List<UserData> participants = [];
  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this event?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Call the function to delete the event from Firebase
                deleteEvent();

                // Close the confirmation dialog
                Navigator.of(context).pop();

                // Navigate back to the home screen or perform any other actions
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> fetchParticipants() async {
    try {
      final List<UserData> fetchedParticipants =
      await EventService.fetchParticipants(eventId: widget.event.eventId);
      setState(() {
        participants = fetchedParticipants;
      });
    } catch (e) {
      print('Error fetching participants: $e');
    }
  }

  void deleteEvent() async {
    try {
      // Call the function to delete the event from Firebase
      await EventService.deleteTask(eventId: widget.event.eventId);
      final featuredEventsController = Get.find<FeaturedEventsController>();
      final trendingEventsController = Get.find<TrendingEventController>();
      final popularEventController = Get.find<PopularEventsController>();
      featuredEventsController.removeEventById(widget.event.eventId);
      trendingEventsController.removeEventById(widget.event.eventId);
      popularEventController.removeEventById(widget.event.eventId);
      // Display a snackbar to indicate successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // You can choose to navigate to a different screen or handle it based on your app's flow
      Navigator.pop(context); // Go back to the home screen
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error deleting event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting event. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomSheet: Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                _confirmDelete();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
            OutlinedButton.icon(
              onPressed: () {

              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: Icon(Icons.edit, color: Colors.blue),
              label: Text("Edit", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),

      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100],
                    image: widget.event.imagepath.isNotEmpty
                        ? DecorationImage(
                      image:
                      NetworkImage(widget.event.imagepath),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors
                            .white, // You can use any color you prefer
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // This will pop the current page and go back

                        // Save the updated favorite status to persistent storage (e.g., database)
                        // You can use a database or SharedPreferences to save this data
                        // Example using SharedPreferences:
                        // saveFavoriteStatus(widget.event);
                      },
                    )),
                Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        widget.event.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors
                            .red, // You can use any color you prefer
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle the isFavorite status
                          widget.event.isFavorite =
                          !widget.event.isFavorite;
                        });

                        // Save the updated favorite status to persistent storage (e.g., database)
                        // You can use a database or SharedPreferences to save this data
                        // Example using SharedPreferences:
                        // saveFavoriteStatus(widget.event);
                      },
                    )),
                // Favorite Button
                Positioned(
                  bottom: -4,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.eventName,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: Colors.grey,
                                ),
                                Text(
                                  widget.event.location,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                Text(
                                  widget.event.date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Participants",
              style: TextStyle(
                fontSize: 20
              ),),

      Column(
        children: participants.map((participant) {
          return ListTile(
            title: Text(participant.username),
            subtitle: Text("Seats booked: ${participant.seatsBooked}"),
            // Add more details if needed
          );
        }).toList(),
      ),
          ],
        ),
      ),
    );
  }
}
