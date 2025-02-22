class TicketData {
  final String ticketId;
  final String eventName;
  final double ticketPrice;
  final int numberOfSeats;

  TicketData({
    required this.ticketId,
    required this.eventName,
    required this.ticketPrice,
    required this.numberOfSeats,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      ticketId: json['ticketId'] as String,
      eventName: json['eventName'] as String,
      ticketPrice: json['ticketPrice'] as double,
      numberOfSeats: json['numberOfSeats'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'eventName': eventName,
      'ticketPrice': ticketPrice,
      'numberOfSeats': numberOfSeats,
    };
  }
}
