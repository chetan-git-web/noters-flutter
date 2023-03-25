// login
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class EmailInvalidAuthException implements Exception {}

// generic exception
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
