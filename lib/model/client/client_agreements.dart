/// The `ClientAgreements` class represents a client's agreements for email, SMS, push notifications,
/// Bluetooth, RFID, and Wi-Fi, and includes methods for setting and getting these agreements, as well
/// as a constructor for creating objects from a `Map`.
class ClientAgreements {
  bool? email;
  bool? sms;
  bool? push;
  bool? bluetooth;
  bool? rfid;
  bool? wifi;

  ClientAgreements({this.email, this.sms, this.push, this.bluetooth, this.rfid, this.wifi});

  void setEmail(bool email) {
    this.email = email;
  }

  void setSms(bool sms) {
    this.sms = sms;
  }

  void setPush(bool push) {
    this.push = push;
  }

  void setBluetooth(bool bluetooth) {
    this.bluetooth = bluetooth;
  }

  void setRfid(bool rfid) {
    this.rfid = wifi;
  }

  void setWifi(bool wifi) {
    this.wifi = wifi;
  }

  bool? getEmail() {
    return email;
  }

  bool? getSms() {
    return sms;
  }

  bool? getPush() {
    return push;
  }

  bool? getBluetooth() {
    return bluetooth;
  }

  bool? getRfid() {
    return rfid;
  }

  bool? getWifi() {
    return wifi;
  }

  /// `ClientAgreements.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// initializes a new `ClientAgreements` object with the values from the `Map`.
  ClientAgreements.fromMap(Map map)
      : this(email: map['email'], sms: map['sms'], push: map['push'], bluetooth: map['bluetooth'], rfid: map['rfid'], wifi: map['wifi']);

  /// This function returns a map containing email, sms, push, bluetooth, rfid, and wifi as keys and
  /// their corresponding values.
  Map asMap() => {'email': email, 'sms': sms, 'push': push, 'bluetooth': bluetooth, 'rfid': rfid, 'wifi': wifi};
}
