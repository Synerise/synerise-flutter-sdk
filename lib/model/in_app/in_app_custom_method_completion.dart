/// Completion handler used to resolve a custom method invoked from an in-app message.
///
class InAppCustomMethodCompletion {
  final void Function(Object? result) _onSuccess;
  final void Function(String errorMessage) _onFailure;
  bool _isDone = false;

  InAppCustomMethodCompletion(this._onSuccess, this._onFailure);

  /// Resolves the pending in-app message Promise. [result] is an optional value of any type
  void success(Object? result) {
    if (!_claim()) {
      return;
    }
    _onSuccess(result);
  }

  void failure(String errorMessage) {
    if (!_claim()) {
      return;
    }
    _onFailure(errorMessage);
  }

  bool _claim() {
    if (_isDone) {
      return false;
    }
    _isDone = true;
    return true;
  }
}
