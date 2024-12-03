// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscountHistoryAdapter extends TypeAdapter<DiscountHistory> {
  @override
  final int typeId = 0;

  @override
  DiscountHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscountHistory(
      date: fields[0] as String,
      originalPrice: fields[1] as String,
      discount: fields[2] as String,
      finalPrice: fields[3] as String,
      profit: fields[4] as String,
      sellPrice: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiscountHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.originalPrice)
      ..writeByte(2)
      ..write(obj.discount)
      ..writeByte(3)
      ..write(obj.finalPrice)
      ..writeByte(4)
      ..write(obj.profit)
      ..writeByte(5)
      ..write(obj.sellPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
