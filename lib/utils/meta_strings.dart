class MetaStrings {
  static const String baseUrl = "http://192.168.0.108:8000";
  static const String socketBaseUrl = "ws://192.168.0.108:8000";
  static const String userUpdateUrl = '$baseUrl/users';
  static const String liveStreamListUrl = "$baseUrl/stream";
  static const String liveStreamJoinUrl = "$liveStreamListUrl/join";
  static const String liveStreamLeaveUrl = "$liveStreamListUrl/leave";
}
