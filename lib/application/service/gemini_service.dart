import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    init();
  }

  // Initialize the service
  void init() {
    // Generation Config
    GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.9,
      topP: 1,
      topK: 0,
      maxOutputTokens: 2048,
      responseMimeType: 'text/plain',
    );

    model = GenerativeModel(
      model: 'tunedModels/expenses-category-v4idghr3vubz',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      generationConfig: generationConfig,
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
