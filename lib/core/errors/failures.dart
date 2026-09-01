class Failure {
  final String errMessage;
  Failure(this.errMessage);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.errMessage);
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.errMessage);
}
