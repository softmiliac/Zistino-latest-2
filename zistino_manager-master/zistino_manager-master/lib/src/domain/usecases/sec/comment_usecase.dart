
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/sec/comment_model.dart';
import '../../entities/sec/comments_item_entity.dart';
import '../../repositories/sec/comment_repository.dart';

class AddCommentUseCase extends ParamUseCase<BaseResponse, CommentModel> {
  final CommentRepository _repo;

  AddCommentUseCase(this._repo);

  @override
  Future<BaseResponse> execute(CommentModel params) {
    return _repo.addComment(params);
  }
}

class UpdateCommentUseCase extends ParamUseCase<BaseResponse, CommentModel> {
  final CommentRepository _repo;

  UpdateCommentUseCase(this._repo);

  @override
  Future<BaseResponse> execute(CommentModel params) {
    return _repo.updateComment(params);
  }
}

class FetchCommentByProductIDUseCase extends ParamUseCase<List<CommentItems>, LazyRQM> {
  final CommentRepository _repo;

  FetchCommentByProductIDUseCase(this._repo);

  @override
  Future<List<CommentItems>> execute(LazyRQM params) {
    return _repo.fetchCommentsByProID(params);
  }
}

class FetchAllCommentUseCase extends ParamUseCase<List<CommentItems>, LazyRQM> {
  final CommentRepository _repo;

  FetchAllCommentUseCase(this._repo);

  @override
  Future<List<CommentItems>> execute(LazyRQM params) {
    return _repo.fetchAllComments(params);
  }
}

class DeleteCommentUseCase extends ParamUseCase<BaseResponse, int> {
  final CommentRepository _repo;

  DeleteCommentUseCase(this._repo);

  @override
  Future<BaseResponse> execute(int params
      // ,int id
      ) {
    return _repo.deleteComment(params);
  }
}

