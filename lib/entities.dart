import 'package:objectbox/objectbox.dart';

@Entity()
class User{
  int id;
  String userName, password;

  User({
    this.id = 0,
    required this.userName,
    required this.password
  });
}