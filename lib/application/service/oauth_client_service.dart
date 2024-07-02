import 'package:http/http.dart' as http;

class OauthHttpClient extends http.BaseClient {
  final String authorizationToken;

  OauthHttpClient(this.authorizationToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $authorizationToken';
    return http.Client().send(request);
  }
}
