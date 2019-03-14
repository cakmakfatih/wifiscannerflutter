class ScanResult {
  final String BSSID;
  final String SSID;
  final String capabilities;
  final int centerFreq0;
  final int centerFreq1;
  final int channelWidth;
  final int frequency;
  final int level;
  final String operatorFriendlyName;
  final int timestamp;
  final String venueName;
  final int signalLevel;

  ScanResult({
    this.BSSID,
    this.SSID,
    this.capabilities,
    this.centerFreq0,
    this.centerFreq1,
    this.channelWidth,
    this.frequency,
    this.level,
    this.operatorFriendlyName,
    this.timestamp,
    this.venueName,
    this.signalLevel
  });
  
  factory ScanResult.fromJson(dynamic json) {
    return ScanResult(
      BSSID: json["BSSID"],
      SSID: json["SSID"],
      capabilities: json["capabilities"],
      centerFreq0: json["centerFreq0"],
      centerFreq1: json["centerFreq1"],
      channelWidth: json["channelWidth"],
      frequency: json["frequency"],
      level: json["level"],
      operatorFriendlyName: json["operatorFriendlyName"],
      timestamp: json["timestamp"],
      venueName: json["venueName"],
      signalLevel: json["signalLevel"]
    );
  }
}

class ScanResults {
  final List<ScanResult> results;

  ScanResults({this.results});

  factory ScanResults.fromJson(dynamic json) {
    return ScanResults(results: (json["results"] as dynamic).map<ScanResult>((dynamic i) => ScanResult.fromJson(i)).toList());
  }
}