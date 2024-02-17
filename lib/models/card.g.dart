// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreditCardAdapter extends TypeAdapter<CreditCard> {
  @override
  final int typeId = 2;

  @override
  CreditCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreditCard(
      cardHolder: fields[0] as String,
      cardNumber: fields[1] as String,
      cardExpiry: fields[2] as String,
      isFavorite: fields[6] as bool,
      cardCvv: fields[3] as String?,
      cardIssuer: fields[4] as String?,
      cardName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreditCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cardHolder)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.cardExpiry)
      ..writeByte(3)
      ..write(obj.cardCvv)
      ..writeByte(4)
      ..write(obj.cardIssuer)
      ..writeByte(5)
      ..write(obj.cardName)
      ..writeByte(6)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
