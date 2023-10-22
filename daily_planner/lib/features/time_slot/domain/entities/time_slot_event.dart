abstract class TimeSlotEvent {
  int? id;
  String name;

  TimeSlotEvent({this.id, required this.name});

  Map<dynamic, dynamic> toJson();
}
