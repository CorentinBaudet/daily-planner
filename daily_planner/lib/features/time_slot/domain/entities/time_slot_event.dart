abstract class TimeSlotEvent {
  int? id;
  final String name;

  TimeSlotEvent({this.id, required this.name});

  Map<dynamic, dynamic> toJson();
}
