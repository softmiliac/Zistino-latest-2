import 'dart:io';

import '../../entities/sec/user.dart';


abstract class UserRepository {
  Future<User?> getUser({bool isFromLocal = true});
  Future<bool> editUser(User model);
  Future<String> uploadFile(File file);

}
