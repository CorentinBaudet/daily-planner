import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'block_state.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit() : super(BlockInitial());
}
