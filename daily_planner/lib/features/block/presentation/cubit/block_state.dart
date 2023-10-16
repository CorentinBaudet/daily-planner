part of 'block_cubit.dart';

sealed class BlockState extends Equatable {
  const BlockState();

  @override
  List<Object> get props => [];
}

final class BlockInitial extends BlockState {}
