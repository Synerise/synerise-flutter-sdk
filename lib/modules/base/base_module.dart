class BaseModule {
  bool isInitialized = false;

  void beforeInitialization() {}
  void afterInitialization() {
    isInitialized = true;
  }
}
