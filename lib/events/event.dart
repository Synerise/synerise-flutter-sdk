/// The class "Event" defines a custom event with a type, label, action, and parameters, and provides
/// a method to convert it to a map.
abstract class Event {
  final String _label;
  final String _action;
  Map<String, Object> parameters;

  Event(this._label, this._action, this.parameters);

  /// The function returns a map with the values of type, label, action, and parameters.
  Map asMap() => {'label': _label, 'action': _action, 'params': parameters};
}
