// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductTemplateAdapter extends TypeAdapter<ProductTemplate> {
  @override
  final int typeId = 1;

  @override
  ProductTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductTemplate(
      name: fields[0] as String,
      category: fields[1] as String,
      imageUrl: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
      useCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductTemplate obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.useCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
