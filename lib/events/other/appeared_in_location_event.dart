import '../custom_event.dart';

/// The class defines two constant strings representing latitude and longitude parameters for an event.
abstract class AppearedInLocationEventParameters {
  static const String lat = 'lat';
  static const String lon = 'lon';

  AppearedInLocationEventParameters._();
}

/// The AppearedInLocationEvent class represents an event where a client has appeared in a specific
/// location, with latitude and longitude parameters.
class AppearedInLocationEvent extends CustomEvent {
  AppearedInLocationEvent(
    String label,
    double lat,
    double lon,
    Map<String, Object>? parameters,
  ) : super(label, 'client.location', parameters) {
    this.parameters[AppearedInLocationEventParameters.lat] = lat;
    this.parameters[AppearedInLocationEventParameters.lon] = lon;
  }
}
