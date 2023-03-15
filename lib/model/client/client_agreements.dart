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

  ClientAgreements.fromMap(Map map)
      : this(email: map['email'], sms: map['sms'], push: map['push'], bluetooth: map['bluetooth'], rfid: map['rfid'], wifi: map['wifi']);

  Map asMap() => {'email': email, 'sms': sms, 'push': push, 'bluetooth': bluetooth, 'rfid': rfid, 'wifi': wifi};
}
