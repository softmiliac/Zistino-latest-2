/// from umar source
abstract class NoParamUseCase<Type> {
  Future<Type> execute();
}
abstract class ParamUseCase<Type, Params> {
  Future<Type> execute(Params params);
}
