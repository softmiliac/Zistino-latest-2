
import '../../../common/usecases/usecase.dart';
import '../../../data/repositories/sec/faq_repository.dart';
import '../../entities/sec/faq.dart';

class FetchAllFaqUseCase extends ParamUseCase<List<FaqEntity>,String> {
  final FaqRepositoryImpl _repo;
  FetchAllFaqUseCase(this._repo);

  @override
  Future<List<FaqEntity>> execute(String params) {
    return _repo.fetchFaq(keyword: params);
  }
}