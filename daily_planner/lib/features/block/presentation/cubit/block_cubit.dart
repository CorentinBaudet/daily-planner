import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/block/domain/repositories/block_base_repository.dart';
import 'package:equatable/equatable.dart';

part 'block_state.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit({required this.repository}) : super(InitialState()) {
    getBlocks();
  }

  final BlockBaseRepository repository;

  void getBlocks() {
    try {
      emit(LoadingState());
      final blocks = repository.getBlocks();
      emit(LoadedState(blocks: blocks));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void createBlock(Block block) async {
    try {
      emit(LoadingState());
      await repository.createBlock(block);
      getBlocks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void updateBlock(Block block) async {
    try {
      emit(LoadingState());
      await repository.updateBlock(block);
      getBlocks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void deleteBlock(int id) async {
    try {
      emit(LoadingState());
      await repository.deleteBlock(id);
      getBlocks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
