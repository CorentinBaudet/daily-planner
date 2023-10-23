import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:daily_planner/constants/intl.dart';
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

  // TODO : scroller le contenu du dropdown pour qu'à l'ouverture il soit centré sur l'heure actuelle
  // TODO : centrer les items dans les dropdowns OU ajuster la longueur des dropdowns aux items
  Row _editStartTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("from", style: TextStyle(color: Theme.of(context).primaryColor)),
        const SizedBox(
          width: 8,
        ),
        DropdownButton(
          items: TimeSlotUseCases().getTodayStartTimes().map((item) {
            return DropdownMenuItem(
              value: Utils().formatTime(item),
              child: Text(
                Utils().formatTime(item),
              ),
            );
          }).toList(),
          value: Utils().formatTime(widget.blockTimeSlot.startTime),
          icon: const Icon(null),
          menuMaxHeight: 250,
          onChanged: (value) {
            setState(() => widget.blockTimeSlot.startTime = DateTime(
                widget.blockTimeSlot.startTime.year,
                widget.blockTimeSlot.startTime.month,
                widget.blockTimeSlot.startTime.day,
                ConstantsIntl.timeFormat.parse(value.toString()).hour,
                ConstantsIntl.timeFormat.parse(value.toString()).minute));
          },
        ),
      ],
    );
  }

  // TODO : mettre les dropdowns sur la même ligne ?
  Row _editEndTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("to", style: TextStyle(color: Theme.of(context).primaryColor)),
        const SizedBox(
          width: 8,
        ),
        DropdownButton(
          items: TimeSlotUseCases().getTodayStartTimes().map((item) {
            return DropdownMenuItem(
              value: Utils().formatTime(item),
              child: Text(
                Utils().formatTime(item),
              ),
            );
          }).toList(),
          value: Utils().formatTime(widget.blockTimeSlot.endTime),
          icon: const Icon(null),
          menuMaxHeight: 250,
          onChanged: (value) {
            setState(() {
              widget.blockTimeSlot.endTime = DateTime(
                  widget.blockTimeSlot.endTime.year,
                  widget.blockTimeSlot.endTime.month,
                  widget.blockTimeSlot.endTime.day,
                  ConstantsIntl.timeFormat.parse(value.toString()).hour,
                  ConstantsIntl.timeFormat.parse(value.toString()).minute);
            });
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
      value: (widget.blockTimeSlot.event as Block).isWork,
      padding: 6.0,
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

  // Row _editDuration(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       IconButton(
  //           onPressed: () {
  //             if (widget.newBlockTimeSlot.duration <= 15) {
  //               return;
  //             }
  //             setState(() {
  //               widget.newBlockTimeSlot.duration -= 15;
  //             });
  //           },
  //           icon: const Icon(Icons.remove_rounded)),
  //       NumberPicker(
  //         axis: Axis.horizontal,
  //         itemCount: 3,
  //         itemWidth: MediaQuery.of(context).size.width * 0.15,
  //         value: widget.newBlockTimeSlot.duration,
  //         minValue: 15,
  //         maxValue: 600,
  //         step: 15,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(color: Colors.black, width: 0.5),
  //         ),
  //         onChanged: (value) =>
  //             setState(() => widget.newBlockTimeSlot.duration = value),
  //       ),
  //       IconButton(
  //           onPressed: () {
  //             if (widget.newBlockTimeSlot.duration >= 600) {
  //               return;
  //             }
  //             setState(() {
  //               widget.newBlockTimeSlot.duration += 15;
  //             });
  //           },
  //           icon: const Icon(Icons.add_rounded)),
  //     ],
  //   );
  // }

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
          _editStartTime(context),
          _editEndTime(context),
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
