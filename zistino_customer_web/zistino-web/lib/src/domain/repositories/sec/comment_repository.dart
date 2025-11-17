import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/sec/comment_model.dart';
import '../../entities/sec/comments_item_entity.dart';

abstract class CommentRepository {
  Future<BaseResponse> addComment(CommentModel _rqm);
  Future<BaseResponse> updateComment(CommentModel _rqm);
  Future<BaseResponse> deleteComment(int id);
  Future<List<CommentItems>> fetchCommentsByProID(LazyRQM _rqm);
  Future<List<CommentItems>> fetchAllComments(LazyRQM _rqm);
}
