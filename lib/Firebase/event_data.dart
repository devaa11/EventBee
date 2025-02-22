class EventData {
  final String eventName;
  final String eventAddress;
  final String location;
  final String price;
  final String date;
  final String starttime;
  final String endtime;
  final String eventdescription;
  final String imagepath;
  final String category;
  final String userId;
  final String username;
  final String profileimg;
  final String coverImageUrl;
  final List<String> mediaImageUrls;
  final String UpiId;
  final String eventId;
  bool isFavorite;

  EventData({
    required this.UpiId,
    required this.coverImageUrl,
    required this.mediaImageUrls,
    required this.eventName,
    required this.eventAddress,
    required this.location,
    required this.price,
    required this.date,
    required this.starttime,
    required this.endtime,
    required this.eventdescription,
    required this.imagepath,
    required this.category,
    required this.userId,
    required this.username,
    required this.profileimg,
    required this.eventId,
    this.isFavorite = false, // Initialize as not favorite

    // Add other fields here
  });
}
