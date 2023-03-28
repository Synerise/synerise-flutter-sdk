abstract class Event {

String type;
String label;
String action;
Map<String, Object> parameters;

Event(this.type, this.label, this.action, this.parameters);

Map asMap() => {'type': type, 'label': label, 'action': action, 'params': parameters};
}