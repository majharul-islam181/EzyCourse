class MemoryStorage {
  
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  void clear() {
    _accessToken = null;
  }
}