sealed class ServiceResult<T> {
  const ServiceResult();
}

final class ServiceSuccess<T> extends ServiceResult<T> {
  const ServiceSuccess(this.data);
  final T data;
}

final class ServiceFailure<T> extends ServiceResult<T> {
  const ServiceFailure(this.error);
  final String error;
}
