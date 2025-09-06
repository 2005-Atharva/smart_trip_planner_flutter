// lib/src/features/chat/data/gemini_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';

class GeminiService {
  final String apiKey;
  final String model;

  GeminiService({required this.apiKey, this.model = 'gemini-2.5-flash'});

  Future<Itinerary> generateItinerary(String userPrompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    final systemAndSchema =
        '''
You are a trip planning assistant. Generate a travel itinerary in strict JSON only, following the schema below. Do not wrap it in a string.

Schema:
{
  "title": string,
  "startDate": string (yyyy-mm-dd),
  "endDate": string (yyyy-mm-dd),
  "days": [
    {
      "date": string (yyyy-mm-dd),
      "summary": string,
      "items": [
        { "time": string (HH:mm), "activity": string, "location": string }
      ]
    }
  ]
}
User request: $userPrompt
''';

    final body = {
      "contents": [
        {
          "parts": [
            {"text": systemAndSchema},
          ],
        },
      ],
      "generationConfig": {
        "responseMimeType": "application/json",
        "responseSchema": {
          "type": "object",
          "properties": {
            "title": {"type": "string"},
            "startDate": {"type": "string"},
            "endDate": {"type": "string"},
            "days": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "date": {"type": "string"},
                  "summary": {"type": "string"},
                  "items": {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "properties": {
                        "time": {"type": "string"},
                        "activity": {"type": "string"},
                        "location": {"type": "string"},
                      },
                      "required": ["time", "activity", "location"],
                    },
                  },
                },
                "required": ["date", "summary", "items"],
              },
            },
          },
          "required": ["title", "startDate", "endDate", "days"],
        },
      },
    };

    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Gemini error ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);
    print(data);

    // Gemini often puts the JSON inside parts[0].text, sometimes double-encoded.
    final partsText = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
    if (partsText == null) throw Exception('No content from model.');

    dynamic decoded = jsonDecode(partsText); // might return Map OR String
    if (decoded is String) {
      decoded = jsonDecode(decoded); // handle the case you shared
    }

    return Itinerary.fromJson(decoded as Map<String, dynamic>);
  }
}
