

class VehicleRqm {
  final String userId;
  final String modelMake;
  final String plateNum;
  final String licence;
  final String bodytype;
  final String color;
  final String manufacturer;
  final String registrationNum;
  final String engineSize;
  final String tank;
  final String numoftyres;
  final String gpsDeviceId;
  final bool active;
  final int latitude;
  final int longitude;
  final String protocol;
  final int port;

  VehicleRqm({
    this.userId = "",
    this.modelMake = "",
    this.plateNum = "",
    this.licence = "",
    this.bodytype = "",
    this.color = "",
    this.manufacturer = "",
    this.registrationNum = "",
    this.engineSize = "",
    this.tank = "",
    this.numoftyres = "",
    this.gpsDeviceId = "",
    this.active = false,
    this.latitude = 0,
    this.longitude = 0,
    this.protocol = "",
    this.port = 0,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'modelMake': modelMake,
    'plateNum': plateNum,
    'licence': licence,
    'bodytype': bodytype,
    'color': color,
    'manufacturer': manufacturer,
    'registrationNum': registrationNum,
    'engineSize': engineSize,
    'tank': tank,
    'numoftyres': numoftyres,
    'gpsDeviceId': gpsDeviceId,
    'active': active,
    'latitude': latitude,
    'longitude': longitude,
    'protocol': protocol,
    'port': port,
  };
}

