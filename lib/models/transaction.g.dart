// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String?,
      createdOn: fields[5] as DateTime?,
      description: fields[1] as String?,
      amount: fields[2] as double,
      transactionType: fields[3] as String,
      category: fields[4] as String,
      mode: fields[6] as Mode,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.transactionType)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.createdOn)
      ..writeByte(6)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModeAdapter extends TypeAdapter<Mode> {
  @override
  final int typeId = 2;

  @override
  Mode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mode.cash;
      case 1:
        return Mode.card;
      default:
        return Mode.cash;
    }
  }

  @override
  void write(BinaryWriter writer, Mode obj) {
    switch (obj) {
      case Mode.cash:
        writer.writeByte(0);
        break;
      case Mode.card:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
