import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/service/oauth_client_service.dart';

class GeminiService {
  late final GenerativeModel model;
  bool isPermissionGranted = false;

  GeminiService() {
    init();
  }

  // Initialize the service
  void init() async {
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
      return 'Error: $e';
    }
  }
}
