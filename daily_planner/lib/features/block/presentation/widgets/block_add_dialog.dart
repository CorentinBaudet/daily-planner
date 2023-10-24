import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_picker.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

// ignore: must_be_immutable
class BlockAddDialog extends StatefulWidget {
  TimeSlot blockTimeSlot = TimeSlot(
      startTime: Utils().troncateDateTime(DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1)),
      endTime: Utils().troncateDateTime(DateTime(DateTime.now().year,
          DateTime.now().month, DateTime.now().day, DateTime.now().hour + 2)),
      event: Block(name: ""),
      createdAt: Utils().troncateDateTime(DateTime.now()));

  TimeSlot? toEditBlock;

  BlockAddDialog({super.key, this.toEditBlock});

  @override
  State<BlockAddDialog> createState() => _BlockAddDialogState();
}

class _BlockAddDialogState extends State<BlockAddDialog> {
  TextEditingController blockNameController = TextEditingController();

  TimeSlotPicker _editStartTime(BuildContext context) {
    return TimeSlotPicker(
      timeSlot: widget.blockTimeSlot,
      isEndTime: false,
    );
  }

  TimeSlotPicker _editEndTime(BuildContext context) {
    return TimeSlotPicker(
      timeSlot: widget.blockTimeSlot,
      isEndTime: true,
    );
  }

  Widget _prioritySwitch() {
    return FlutterSwitch(
      width: 70.0,
      height: 27.0,
      valueFontSize: 13.0,
      toggleSize: 21.0,
      value: (widget.blockTimeSlot.event as Block).isWork,
      padding: 5.0,
      showOnOff: true,
      inactiveText: '',
      activeText: 'work',
      onToggle: (val) {
        setState(() {
          (widget.blockTimeSlot.event as Block).isWork = val;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.toEditBlock != null) {
      widget.blockTimeSlot = widget.toEditBlock!;
      blockNameController.text = widget.toEditBlock!.event.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: widget.toEditBlock != null
          ? const Text('edit block')
          : const Text('new block'),
      insetPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Form(
                key: formKey,
                child: Expanded(
                  child: TextFormField(
                    controller: blockNameController,
                    decoration: const InputDecoration(
                      hintText: 'block name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofocus: widget.toEditBlock == null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              _prioritySwitch(),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _editStartTime(context),
              _editEndTime(context),
            ],
          ),
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
        _addButton(context, formKey),
      ],
    );
  }

  TextButton _addButton(BuildContext context, GlobalKey<FormState> formKey) {
    return TextButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateColor.resolveWith(
              (Set<MaterialState> states) => Colors.white),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary)),
      onPressed: () {
        if (!formKey.currentState!.validate()) {
          return;
        }

        if (widget.toEditBlock != null) {
          context.read<TimeSlotCubit>().updateTimeSlot(TimeSlot(
              id: widget.toEditBlock!.id,
              startTime:
                  Utils().troncateDateTime(widget.blockTimeSlot.startTime),
              endTime: Utils().troncateDateTime(widget.blockTimeSlot.endTime),
              event: Block(
                  name: blockNameController.text,
                  isWork: (widget.blockTimeSlot.event as Block).isWork),
              createdAt: widget.toEditBlock!.createdAt));
          // close the dialog
          Navigator.of(context).pop();
          return;
        }
        context.read<TimeSlotCubit>().createTimeSlot(TimeSlot(
            startTime: Utils().troncateDateTime(widget.blockTimeSlot.startTime),
            endTime: Utils().troncateDateTime(widget.blockTimeSlot.endTime),
            event: Block(
                name: blockNameController.text,
                isWork: (widget.blockTimeSlot.event as Block).isWork),
            createdAt: Utils().troncateDateTime(DateTime.now())));

        // close the dialog
        Navigator.of(context).pop();
      },
      child:
          widget.toEditBlock != null ? const Text('edit') : const Text('add'),
    );
  }
}
