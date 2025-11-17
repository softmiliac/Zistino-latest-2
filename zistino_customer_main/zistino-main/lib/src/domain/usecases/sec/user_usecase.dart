import 'dart:io';

import 'package:zistino/src/data/models/base/base_response.dart';

import '../../../common/usecases/usecase.dart';
import '../../../data/repositories/sec/user_repository.dart';
import '../../entities/sec/user.dart';
import '../../entities/sec/user_zone.dart';
import '../../repositories/sec/user_repository.dart';


class UserUseCase extends NoParamUseCase<User?> {
  final UserRepositoryImpl _repository = UserRepositoryImpl();


  @override
  Future<User?> execute() {
    return _repository.getUser();
  }
}

class SetRepresentativeUseCase extends ParamUseCase<bool, String> {
  final UserRepositoryImpl _repository = UserRepositoryImpl();

  @override
  Future<bool> execute(String params) {
    return _repository.setRepresentative(params);
  }
}

class SearchUserInZoneUseCase extends ParamUseCase<List<UserZoneEntity>, int> {
  final UserRepositoryImpl _repository = UserRepositoryImpl();

  @override
  Future<List<UserZoneEntity>> execute(int params) {
    return _repository.searchUserInZone(params);
  }
}

class EditUserUseCase extends ParamUseCase<bool, User> {
  final UserRepositoryImpl _repo = UserRepositoryImpl();
  @override
  Future<bool> execute(User params) {
    return _repo.editUser(params);
  }
}

class UploadFileUseCase extends ParamUseCase<String, File> {
  final UserRepository _repoUpload;

  UploadFileUseCase(this._repoUpload);

  @override
  Future<String> execute(File params) {
    return _repoUpload.uploadFile(params);
  }

}