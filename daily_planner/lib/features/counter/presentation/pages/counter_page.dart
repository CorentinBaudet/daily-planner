import 'package:daily_planner/features/counter/presentation/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Counter Page'),
        ),
        body: BlocBuilder<CounterCubit, int>(
          builder: (context, state) => Center(
            child: Text(
              '$state',
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<CounterCubit>().increment(),
          child: const Icon(Icons.add),
        ));
  }
}
