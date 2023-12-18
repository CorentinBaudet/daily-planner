import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotDataSource extends CalendarDataSource {
  // Singleton instance
  static final TimeSlotDataSource _singleton = TimeSlotDataSource._internal();

  // Named constructor
  TimeSlotDataSource._internal();

  // Factory method to return the same instance
  factory TimeSlotDataSource() {
    return _singleton;
  }

  // TimeSlotDataSource(List<TimeSlot> source) {
  //   appointments = source;
  // }

  List<TimeSlot> get timeSlots {
    return appointments as List<TimeSlot>;
  }

  set timeSlots(List<TimeSlot> source) {
    appointments = timeSlots;
  }

  // Returns the TimeSlotDataSource
  void buildTimeSlotDataSource(List<TimeSlot> storedTimeSlots,
      {bool isTomorrow = false}) {
    List<TimeSlot> builtTimeSlots =
        <TimeSlot>[]; // the SfCalendar requires a list of Appointment objects to build the data source

    for (var timeSlot in storedTimeSlots) {
      switch (timeSlot.runtimeType) {
        case Task:
          if ((timeSlot as Task).isPlanned) {
            // If the task is planned, we add it to the calendar
            builtTimeSlots.add(timeSlot);
          }
          break;

        case Block:
          _handleBlock(builtTimeSlots, timeSlot);
          break;

        case WorkBlock:
          _handleWorkBlock(builtTimeSlots, timeSlot, isTomorrow);
          break;

        default:
          // TODO: handle this case by logging an error
          break;
      }
    }

    // update the tasks visually if they are passed
    // _handleTasksPassed(context, builtTimeSlots);

    // update the data source
    appointments = builtTimeSlots;

    // return TimeSlotDataSource();
  }

  static void _handleBlock(List<TimeSlot> builtTimeSlots, TimeSlot timeSlot) {
    // if the end time is before the start time, it means that the block ends the next day
    bool isOverlap =
        timeSlot.endTime.isBefore(timeSlot.startTime) ? true : false;

    // if the block ends the next day, we add it again to the calendar the next day
    if (!isOverlap) {
      builtTimeSlots.add(timeSlot);
      return;
    }

    builtTimeSlots.add(Block(
      id: timeSlot.id,
      startTime: timeSlot.startTime,
      endTime: DateTime(
          timeSlot.endTime.year,
          timeSlot.endTime.month,
          timeSlot.startTime.day,
          // in case of overlap, end at 24:00 makes a double arrow appear which hides the block name
          23,
          59),
      recurrenceRule: timeSlot.recurrenceRule,
      subject: timeSlot.subject,
      color: timeSlot.color,
      createdAt: timeSlot.createdAt,
    ));
    builtTimeSlots.add(_addOverlap(timeSlot));
  }

  static void _handleWorkBlock(
      List<TimeSlot> builtTimeSlots, TimeSlot timeSlot, bool isTomorrow) {
    builtTimeSlots.add(timeSlot);

    return;
  }

  // mettre un attribut isOverlapped dans la classe Block pour faire la différence ?
  static Block _addOverlap(TimeSlot timeSlot, {bool isTomorrow = false}) {
    return Block(
      startTime: DateTime(DateTime.now().year, DateTime.now().month,
          isTomorrow ? DateTime.now().day + 1 : DateTime.now().day, 0, 0),
      endTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
          timeSlot.endTime.hour,
          timeSlot.endTime.minute),
      subject: timeSlot.subject,
      recurrenceRule: timeSlot.recurrenceRule,
      id: timeSlot.id,
      color: timeSlot.color,
      createdAt: timeSlot.createdAt,
    );
  }

  // static void _handleTasksPassed(
  //     BuildContext context, List<Appointment> appointments) {
  //   for (var appointment in appointments) {
  //     if (appointment.appointmentType != AppointmentType.normal) {
  //       continue;
  //     }
  //     // if the appointment is passed, we change its color to grey
  //     if (appointment.endTime.isBefore(DateTime.now())) {
  //       appointment.color = Colors.grey.shade300;
  //       // TimeSlot timeSlot = context
  //       //     .read<TimeSlotCubit>()
  //       //     .repository
  //       //     .getTimeSlot(appointment.id as int);
  //       // Task task = context
  //       //     .read<TaskCubit>()
  //       //     .repository
  //       //     .getTask((timeSlot.event as Task).id as int);
  //       // task.isPlanned = true;
  //     }
  //   }
  // }
}
