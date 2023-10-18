import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockAddDialog extends StatefulWidget {
  const BlockAddDialog({super.key});

  @override
  State<BlockAddDialog> createState() => _BlockAddDialogState();
}

class _BlockAddDialogState extends State<BlockAddDialog> {
  final blockNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text('new block'),
      insetPadding: const EdgeInsets.all(0),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: blockNameController,
          decoration: const InputDecoration(
            hintText: 'block name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'please enter a name';
            }
            return null;
          },
        ),
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
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    15)),
                duration: 60,
                event: Block(name: blockNameController.text, isWork: true),
                createdAt: Utils().troncateDateTime(DateTime.now())));

            // context.read<BlockCubit>().createBlock(
            //     Block(name: blockNameController.text, isWork: true));
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('add'),
        ),
      ],
    );
  }
}
