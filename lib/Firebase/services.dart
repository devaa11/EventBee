import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/UserData.dart';
import 'event_data.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^[0-9]*$');
    if (!regExp.hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with email and password
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user was created successfully
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user was logged in successfully
      final User? user = userCredential.user;
      if (user != null) {
        return user;
      }
    } catch (e) {
      print('Error during login: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
// Other authentication methods...
}

class EventService {
  static Future<List<EventData>> fetchEvents() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance.collection('events').get();

      final List<EventData> events = eventSnapshot.docs.map((eventDoc) {
        final data = eventDoc.data() ?? {}; // Handle null data
        final List<String> mediaURLs =
            (data['mediaImageUrls'] as List<dynamic>?)?.cast<String>() ?? [];
        final String firstImageURL =
            mediaURLs.isNotEmpty ? mediaURLs.first : '';

        // Separate field for cover image URL
        final String coverImageUrl = data['coverImageUrl'] as String? ?? '';

        // Handle null values or unexpected types gracefully
        final String eventName = data['eventName'] as String? ?? '';
        final String location = data['location'] as String? ?? '';
        final String imagepath = coverImageUrl;
        final String eventAddress = data['eventAddress'] as String? ?? '';
        final String price = data['price'] as String? ?? '';
        final String date = data['date'] as String? ?? '';
        final String starttime = data['startTime'] as String? ?? '';
        final String endtime = data['endTime'] as String? ?? '';
        final String eventdescription =
            data['eventDescription'] as String? ?? '';
        final String category = data['category'] as String? ?? '';
        final String userId = data['userId'] as String? ?? '';
        final String username = data['username'] as String? ?? '';
        final String profileimg = data['profileimg'] as String? ?? '';
        final String UpiId = data['UpiId'] as String? ?? '';
        final String eventId = data['eventId'] as String? ?? '';

        return EventData(
          eventName: eventName,
          location: location,
          imagepath: coverImageUrl,
          eventAddress: eventAddress,
          price: price,
          date: date,
          starttime: starttime,
          endtime: endtime,
          eventdescription: eventdescription,
          category: category,
          userId: userId,
          username: username,
          profileimg: profileimg,
          coverImageUrl: coverImageUrl, // Add cover image URL
          mediaImageUrls: mediaURLs, // Keep media image URLs
          UpiId: UpiId,
          eventId: eventId,
        );
      }).toList();

      return events;
    } catch (e) {
      // Handle any errors that occur during fetching or data processing
      print('Error fetching events: $e');
      return [];
    }
  }

  static Future<List<EventData>> fetchEventsSortedByTimestamp() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .orderBy('timestamp', descending: true)
              .get();

      final List<EventData> events = eventSnapshot.docs.map((eventDoc) {
        final data = eventDoc.data() ?? {}; // Handle null data
        final List<String> mediaURLs =
            (data['mediaImageUrls'] as List<dynamic>?)?.cast<String>() ?? [];
        final String firstImageURL =
            mediaURLs.isNotEmpty ? mediaURLs.first : '';
        final String coverImageUrl = data['coverImageUrl'] as String? ?? '';

        // Handle null values or unexpected types gracefully
        final String eventName = data['eventName'] as String? ?? '';
        final String location = data['location'] as String? ?? '';
        final String imagepath = coverImageUrl;
        final String eventAddress = data['eventAddress'] as String? ?? '';
        final String price = data['price'] as String? ?? '';
        final String date = data['date'] as String? ?? '';
        final String starttime = data['startTime'] as String? ?? '';
        final String endtime = data['endTime'] as String? ?? '';
        final String eventdescription =
            data['eventDescription'] as String? ?? '';
        final String category = data['category'] as String? ?? '';
        final String userId = data['userId'] as String? ?? '';
        final String username = data['username'] as String? ?? '';
        final String profileimg = data['profileimg'] as String? ?? '';
        final String UpiId = data['UpiId'] as String? ?? '';
        final String eventId = data['eventId'] as String? ?? '';

        return EventData(
          eventName: eventName,
          location: location,
          imagepath: coverImageUrl,
          eventAddress: eventAddress,
          price: price,
          date: date,
          starttime: starttime,
          endtime: endtime,
          eventdescription: eventdescription,
          category: category,
          userId: userId,
          username: username,
          profileimg: profileimg,
          coverImageUrl: coverImageUrl, // Add cover image URL
          mediaImageUrls: mediaURLs, // Keep media image URLs
          UpiId: UpiId,
          eventId: eventId,
        );
      }).toList();

      return events;
    } catch (e) {
      // Handle any errors that occur during fetching or data processing
      print('Error fetching events sorted by timestamp: $e');
      return [];
    }
  }


  static Future<void> deleteTask({String? eventId}) async {
    try {
      print('Deleting event with ID: $eventId');
      if (eventId != null) {
        await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
        // Task deleted successfully
        print('Event deleted successfully.');
      } else {
        // Handle the case where eventId is null
        print('Error deleting task: Event ID is null.');
      }
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting task: $e');
    }
  }
  static Future<List<UserData>> fetchParticipants({required String eventId}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> participantsSnapshot =
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .get();

      final List<UserData> participants = participantsSnapshot.docs.map((participantDoc) {
        final data = participantDoc.data() ?? {};
        // Adjust the field names based on your actual data structure
        final String userId = data['userId'] as String? ?? '';
        final int seatsBooked = data['seatsBooked'] as int? ?? 0;
        final String username = data['username'] as String? ?? '';
        final String phoneNumber = data['phoneNumber'] as String? ?? '';

        return UserData(
          userId: userId,
          seatsBooked: seatsBooked,
          username: username,
          phoneNumber: phoneNumber,
          // Add more user information as needed
        );
      }).toList();

      return participants;
    } catch (e) {
      print('Error fetching participants: $e');
      return [];
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<EventData>> fetchEventsCreatedByUser() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> eventSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where('userId', isEqualTo: currentUserId)
              .get();

      final List<EventData> events = eventSnapshot.docs.map((eventDoc) {
        final data = eventDoc.data();

        // Check if mediaURLs is not null before casting
        final List<String> mediaURLs =
            (data['mediaURLs'] as List<dynamic>?)?.cast<String>() ?? [];
        final String firstImageURL =
            mediaURLs.isNotEmpty ? mediaURLs.first : '';
        final String coverImageUrl = data['coverImageUrl'] as String? ?? '';

        // Handle null values or unexpected types gracefully
        final String eventName = data['eventName'] as String? ?? '';
        final String location = data['location'] as String? ?? '';
        final String imagepath = coverImageUrl;
        final String eventAddress = data['eventAddress'] as String? ?? '';
        final String price = data['price'] as String? ?? '';
        final String date = data['date'] as String? ?? '';
        final String starttime = data['startTime'] as String? ?? '';
        final String endtime = data['endTime'] as String? ?? '';
        final String eventdescription =
            data['eventDescription'] as String? ?? '';
        final String category = data['category'] as String? ?? '';
        final String userId = data['userId'] as String? ?? '';
        final String username = data['username'] as String? ?? '';
        final String profileimg = data['profileimg'] as String? ?? '';
        final String UpiId = data['UpiId'] as String? ?? '';
        final String eventId = data['eventId'] as String? ?? '';

        return EventData(
          eventName: eventName,
          location: location,
          imagepath: coverImageUrl,
          eventAddress: eventAddress,
          price: price,
          date: date,
          starttime: starttime,
          endtime: endtime,
          eventdescription: eventdescription,
          category: category,
          userId: userId,
          username: username,
          profileimg: profileimg,
          coverImageUrl: coverImageUrl,
          mediaImageUrls: mediaURLs,
          UpiId: UpiId,
          eventId: eventId,
        );
      }).toList();

      return events;
    } catch (e) {
      // Handle any errors that occur during fetching or data processing
      print('Error fetching events created by user: $e');
      return [];
    }
  }
}

