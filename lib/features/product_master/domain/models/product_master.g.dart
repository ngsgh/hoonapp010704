// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_master.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductMasterAdapter extends TypeAdapter<ProductMaster> {
  @override
  final int typeId = 2;

  @override
  ProductMaster read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductMaster(
      name: fields[0] as String,
      category: fields[1] as String,
      imageUrl: fields[2] as String?,
      useCount: fields[3] as int,
      purchaseUrl: fields[5] as String?,
      storeName: fields[6] as String?,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductMaster obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.useCount)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.purchaseUrl)
      ..writeByte(6)
      ..write(obj.storeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductMasterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
