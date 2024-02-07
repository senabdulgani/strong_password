import 'package:hive/hive.dart';

part 'password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  String name;

  @HiveField(1)
  String password;

  Password({required this.name, required this.password});
}
