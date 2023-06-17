/// The class "BaseModule" has methods for initialization and a boolean variable to track if it has been
/// initialized.
class BaseModule {
  bool isInitialized = false;

  void beforeInitialization() {}
  void afterInitialization() {
    isInitialized = true;
  }
}
