import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/oauth_client_service.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  late final GenerativeModel model;
  bool isPermissionGranted = false;

  GeminiService(bool isAdvice) {
    if (isAdvice) {
      initStandardModel();
    } else {
      initTunedModel();
    }
  }

  Future<void> refreshToken() async {
    if (MemberCache.oauthAccessToken == null) {
      try {
        const scopes = [
          'https://www.googleapis.com/auth/cloud-platform',
          'https://www.googleapis.com/auth/cloud-platform.read-only',
        ];

        final response = await http.post(
          Uri.parse('https://oauth2.googleapis.com/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'refresh_token',
            'refresh_token': dotenv.env['GEMINI_REFRESH_TOKEN']!,
            'client_id': dotenv.env['GEMINI_CLIENT_ID']!,
            'client_secret': dotenv.env['GEMINI_CLIENT_SECRET']!,
            'scope': scopes.join(' '),
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);

          await const FlutterSecureStorage().write(
            key: ' oauthAccessToken',
            value: data['access_token'],
          );
          MemberCache.oauthAccessToken = data['access_token'];
        } else {
          dev.log('Error: ${response.body}');
        }
      } catch (e) {
        dev.log('Error: $e');
      }
    }
  }

  // Initialize the standard model service (For advice)
  void initStandardModel() async {
    // Generation Config
    GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.9,
      topP: 1,
      topK: 0,
      maxOutputTokens: 2048,
      responseMimeType: 'text/plain',
    );

    if (MemberCache.oauthAccessToken == null) {
      return;
    }

    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      generationConfig: generationConfig,
    );
  }

  // Initialize the tune model service (For identify category)
  void initTunedModel() async {
    await refreshToken();

    // Generation Config
    GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.9,
      topP: 1,
      topK: 0,
      maxOutputTokens: 2048,
      responseMimeType: 'text/plain',
    );

    if (MemberCache.oauthAccessToken == null) {
      return;
    }

    model = GenerativeModel(
      model: 'tunedModels/expenses-category-v4idghr3vubz',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      generationConfig: generationConfig,
      httpClient: OauthHttpClient(MemberCache.oauthAccessToken ?? ''),
    );
  }

  // Category Prediction
  Future<String> predictCategory(String input) async {
    try {
      final response = await model.generateContent([
        Content.text("input: $input"),
        Content.text("output: "),
      ]);

      return response.text ?? 'No response';
    } catch (e) {
      dev.log('Error: ${e.toString()}');

      return 'Error: $e';
    }
  }

  // Advice Generation
  Future<String> generateAdvice() async {
    String prompt = "";

    Map<Category, double> categoryUsed =
        ExpenseService().getTotalExpensesByCategory(DateTime.now().month);

    if (categoryUsed.isNotEmpty) {
      String categoryString = '';

      categoryUsed.forEach((key, value) {
        categoryString += '${key.categoryName}: ${value.toStringAsFixed(2)}\n';
      });

      prompt =
          '''I spent the following amount on each category this month:\n$categoryString. 
      What advice do you have for me?''';
    } else {
      // Random advice use rand() function
      int random = Random().nextInt(3);

      switch (random) {
        case 0:
          prompt = 'I want to know how to save money.';
          break;
        case 1:
          prompt = 'I want to know how to invest money.';
          break;
        case 2:
          prompt = 'I want to know how to manage money.';
          break;
        default:
          prompt = 'I want to know how to save money.';
      }
    }

    // Add more words to prompt
    prompt +=
        'Advice should be within 200 words. Start with "Looking at your current scenario, I suggest ..."';

    try {
      final response = await model.generateContent([
        Content.text("input: $prompt"),
        Content.text("output: "),
      ]);

      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
