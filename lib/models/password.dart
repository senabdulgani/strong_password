// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  String name;

  @HiveField(1)
  String password;

  @HiveField(2)
  DateTime? createdAt;

  @HiveField(3)
  bool? isFavorite = false;

  @HiveField(4)
  String? website;

  @HiveField(5)
  String? note;

  Password({
    required this.name,
    required this.password,
    this.createdAt,
    this.isFavorite,
    this.website,
    this.note,
  });
}