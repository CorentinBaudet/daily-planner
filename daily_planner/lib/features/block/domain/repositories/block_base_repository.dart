import 'package:daily_planner/features/block/domain/entities/block_entity.dart';

abstract class BlockBaseRepository {
  List<Block> getBlocks();
  Block getBlock(int id);
  Future<void> createBlock(Block block);
  Future<void> updateBlock(Block block);
  Future<void> deleteBlock(int id);
}
