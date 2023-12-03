abstract class TimeSlotEvent {
  final DateTime createdAt;

  TimeSlotEvent({required this.createdAt});

  Map<dynamic, dynamic> toJson();
}
