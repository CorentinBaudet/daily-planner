import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:daily_planner/constants/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class BlockAddDialog extends StatefulWidget {
  TimeSlot newBlockTimeSlot = TimeSlot(
      startTime: Utils().troncateDateTime(DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1)),
      duration: 60,
      event: Block(name: ""),
      createdAt: Utils().troncateDateTime(DateTime.now()));

  BlockAddDialog({super.key});

  @override
  State<BlockAddDialog> createState() => _BlockAddDialogState();
}

class _BlockAddDialogState extends State<BlockAddDialog> {
  final blockNameController = TextEditingController();

  Row _editStartTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("start time: ",
            style: TextStyle(color: Theme.of(context).primaryColor)),
        const SizedBox(
          width: 8,
        ),
        DropdownButton(
          items: TimeSlotUseCases().getStartTimeSlots().map((item) {
            return DropdownMenuItem(
              value: Utils().formatTime(item),
              child: Text(
                Utils().formatTime(item),
              ),
            );
          }).toList(),
          value: Utils().formatTime(widget.newBlockTimeSlot.startTime),
          icon: const Icon(null),
          menuMaxHeight: 250,
          onChanged: (value) {
            setState(() => widget.newBlockTimeSlot.startTime = DateTime(
                widget.newBlockTimeSlot.startTime.year,
                widget.newBlockTimeSlot.startTime.month,
                widget.newBlockTimeSlot.startTime.day,
                ConstantsIntl.timeFormat.parse(value.toString()).hour,
                ConstantsIntl.timeFormat.parse(value.toString()).minute));
          },
        ),
      ],
    );
  }

  Widget _prioritySwitch() {
    return FlutterSwitch(
      width: 75.0,
      height: 30.0,
      valueFontSize: 15.0,
      toggleSize: 25.0,
      value: (widget.newBlockTimeSlot.event as Block).isWork,
      padding: 6.0,
      showOnOff: true,
      inactiveText: '',
      activeText: 'work',
      onToggle: (val) {
        setState(() {
          (widget.newBlockTimeSlot.event as Block).isWork = val;
        });
      },
    );
  }

  Row _editDuration(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              if (widget.newBlockTimeSlot.duration <= 15) {
                return;
              }
              setState(() {
                widget.newBlockTimeSlot.duration -= 15;
              });
            },
            icon: const Icon(Icons.remove_rounded)),
        NumberPicker(
          axis: Axis.horizontal,
          itemCount: 3,
          itemWidth: MediaQuery.of(context).size.width * 0.15,
          value: widget.newBlockTimeSlot.duration,
          minValue: 15,
          maxValue: 600,
          step: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          onChanged: (value) =>
              setState(() => widget.newBlockTimeSlot.duration = value),
        ),
        IconButton(
            onPressed: () {
              if (widget.newBlockTimeSlot.duration >= 600) {
                return;
              }
              setState(() {
                widget.newBlockTimeSlot.duration += 15;
              });
            },
            icon: const Icon(Icons.add_rounded)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const Text('new block'),
      insetPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: TextFormField(
              controller: blockNameController,
              decoration: const InputDecoration(
                hintText: 'block name',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _editStartTime(context),
              _prioritySwitch(),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          _editDuration(context),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('cancel'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                  (Set<MaterialState> states) => Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }
            context.read<TimeSlotCubit>().createTimeSlot(TimeSlot(
                startTime: Utils().troncateDateTime(DateTime(
                  widget.newBlockTimeSlot.startTime.year,
                  widget.newBlockTimeSlot.startTime.month,
                  widget.newBlockTimeSlot.startTime.day,
                  widget.newBlockTimeSlot.startTime.hour,
                  widget.newBlockTimeSlot.startTime.minute,
                )),
                duration: widget.newBlockTimeSlot.duration,
                event: Block(
                    name: blockNameController.text,
                    isWork: (widget.newBlockTimeSlot.event as Block).isWork),
                createdAt: Utils().troncateDateTime(DateTime.now())));

            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('add'),
        ),
      ],
    );
  }
}
