import 'dart:io';

import '../../../common/usecases/usecase.dart';
import '../../entities/sec/user.dart';
import '../../repositories/sec/user_repository.dart';


class UserUseCase extends NoParamUseCase<User?> {
  final UserRepository _repository;

  UserUseCase(this._repository);

  @override
  Future<User?> execute() {
    return _repository.getUser();
  }
}

class EditUserUseCase extends ParamUseCase<bool, User> {
  final UserRepository _repo;

  EditUserUseCase(this._repo);

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