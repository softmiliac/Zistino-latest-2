import 'dart:io';
import '../../entities/sec/user.dart';
import '../../entities/sec/user_zone.dart';


abstract class UserRepository {
  Future<User?> getUser({bool isFromLocal = true});
  Future<bool> editUser(User model);
  Future<String> uploadFile(File file);
  Future<List<UserZoneEntity>> searchUserInZone(int zoneId);
  Future<bool> setRepresentative(String representativeCode);
}
