
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/comments_item_entity.dart';
import '../../../domain/repositories/sec/comment_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rqm.dart';
import '../../models/sec/comment_model.dart';
import '../../models/sec/comments_items_model.dart';
import '../../providers/remote/sec/comment_api.dart';

class CommentRepositoryImpl extends CommentRepository {
  @override
  Future<BaseResponse> addComment(CommentModel _rqm) async {
    try {
      BaseResponse response = await CommentAPI().insert(_rqm);
      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<List<CommentItems>> fetchCommentsByProID(LazyRQM _rqm) async{
    try {
      BaseResponse response = await CommentAPI().fetchByProductId(_rqm);

      List<CommentItems> result = CommentsItemsModel.fromJsonList(response.data as List); //todo lazy rpm
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<List<CommentItems>> fetchAllComments(LazyRQM _rqm) async{
    try {
      BaseResponse response = await CommentAPI().fetchAll(_rqm);

      List<CommentItems> result = CommentsItemsModel.fromJsonList(response.data as List); //todo lazy rpm
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<BaseResponse> updateComment(CommentModel _rqm) async {
    try {
      // LocalStorageService _pref = Get.find();

      // if (_pref.token != LocalStorageService.defaultTokenValue) {
      BaseResponse response = await CommentAPI().update(_rqm, _rqm.id ?? 0);

      return response;
      // } else {
      //   return BaseResponse(succeeded: true, data: true, messages: []);
      // }
    } catch (e) {

      AppLogger.catchLog(e);
      rethrow;
    }
  }


  @override
  Future<BaseResponse> deleteComment(int id, {bool fromLocal = true}) async {
    try {
      BaseResponse response = await CommentAPI().delete(id); //todo set id

      return response;
    } catch (e) {

      AppLogger.catchLog(e);
      rethrow;
    }
  }
}
