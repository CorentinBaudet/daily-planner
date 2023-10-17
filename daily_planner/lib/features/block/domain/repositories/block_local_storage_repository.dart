import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/block/domain/repositories/block_base_repository.dart';
import 'package:hive/hive.dart';

class BlockLocalStorageRepository implements BlockBaseRepository {
  final Box _myBlocks = Hive.box('my_blocks');

  BlockLocalStorageRepository();

  @override
  List<Block> getBlocks() {
    final blocks = _myBlocks.values;

    List<Block> blockList = [];

    for (var block in blocks) {
      blockList.add(Block.fromJson(block));
    }
    return blockList;
  }

  @override
  Block getBlock(int id) {
    final block = getBlocks().firstWhere((block) => block.id == id);

    return block;
  }

  @override
  Future<void> createBlock(Block block) {
    block.id = block.hashCode;
    return _myBlocks.put(block.id, block.toJson());
  }

  @override
  Future<void> updateBlock(Block block) {
    return _myBlocks.put(block.id, block.toJson());
  }

  @override
  Future<void> deleteBlock(int id) {
    return _myBlocks.delete(id);
  }
}
