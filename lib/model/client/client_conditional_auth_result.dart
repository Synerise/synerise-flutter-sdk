import '../../enums/client/client_conditional_auth_status.dart';

/// The class `ClientConditionalAuthResult` represents the result of a conditional authentication
/// process, including the status and conditions.
class ClientConditionalAuthResult {
  final ClientConditionalAuthStatus? status;
  final List<Object>? conditions;

  ClientConditionalAuthResult({
    this.status,
    this.conditions,
  });

  /// The `ClientConditionalAuthResult.fromMap(Map map)` method is a constructor that takes a `Map` as
  /// input and creates a new instance of `ClientConditionalAuthResult` based on the values in the map.
  ClientConditionalAuthResult.fromMap(Map map)
      : this(
            status: ClientConditionalAuthStatus.getClientConditionalAuthStatusFromString(map['status']),
            conditions: map['conditions'] != null ? List<Object>.from(map['conditions']) : null);

  /// The function "asMap" returns a map with the "status" and "conditions" properties.
  Map asMap() => {'status': status, 'conditions': conditions};
}
