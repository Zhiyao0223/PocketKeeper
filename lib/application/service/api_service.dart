/*
Include all the HTTP methods here
*/
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:pocketkeeper/application/app_constant.dart';
import 'dart:convert';
import 'package:pocketkeeper/widget/exception_handler_toast.dart';

class ApiService {
  ApiService();

  static Future<dynamic> get({
    required String filename,
    var header = const {},
  }) async {
    return _request(filename: filename, method: 'GET', header: header);
  }

  static Future<dynamic> post({
    required String filename,
    required Map<String, dynamic> body,
  }) async {
    return _request(filename: filename, method: 'POST', body: body);
  }

  static Future<dynamic> put({
    required String filename,
    required Map<String, dynamic> body,
  }) async {
    return _request(filename: filename, method: 'PUT', body: body);
  }

  static Future<dynamic> _request({
    required String filename,
    required String method,
    Map<String, dynamic> body = const {},
    Map<String, String> header = const {},
  }) async {
    var responseJson = {};

    // Initialize url
    var url = Uri.parse('$apiUrl$filename');

    try {
      // GET method
      if (method == 'GET') {
        final response = (header.isEmpty)
            ? await http.get(url)
            : await http.get(url, headers: header);

        responseJson = _returnResponse(response);
      }
      // POST method
      else if (method == 'POST') {
        final response = await http.post(url, body: body);
        responseJson = _returnResponse(response);
      }
      // PUT method
      else if (method == 'PUT') {
        final response = await http.put(url, body: body);
        responseJson = _returnResponse(response);
      } else {
        throw Exception('Invalid method');
      }
    } catch (e) {
      ExceptionHandler.handleException(e);
    }

    return responseJson;
  }

  static Future<dynamic> multipartRequest({
    required String filename,
    required Map<String, dynamic> body,
    required XFile image,
  }) async {
    var responseJson = {};

    // Initialize url
    var url = Uri.parse('$apiUrl$filename');

    try {
      var request = http.MultipartRequest('POST', url);

      // Add image
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      // Add body
      body.forEach((key, value) {
        request.fields[key] = value;
      });

      // Send request
      var streamData = await request.send();

      // Get response
      var response = await http.Response.fromStream(streamData);
      responseJson = _returnResponse(response);
    } catch (e) {
      ExceptionHandler.handleException(e);
    }

    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        ExceptionHandler.handleException(response.body.toString());
      case 401:
      case 403:
        ExceptionHandler.handleException(response.body.toString());
      case 500:
      default:
        ExceptionHandler.handleException(response.body.toString());
    }

    return null;
  }
}
