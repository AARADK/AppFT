import 'dart:convert';
import 'package:flutter_application_1/features/ask_a_question/model/question_category_model.dart';
import 'package:flutter_application_1/features/ask_a_question/model/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart'; // Ensure Hive is set up for secure storage

class AskQuestionRepository {
  final String categoryUrl = "http://52.66.24.172:7001/frontend/GuestQuestion/GetQuestionCategory?type_id=0";
  final String questionUrl = "http://52.66.24.172:7001/frontend/GuestQuestion/GetQuestion?question_category_id=";

  Future<List<QuestionCategory>> fetchCategories() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['question_category'] as List;
        return data.map((json) => QuestionCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<Question>> fetchQuestions(String categoryId) async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Retrieve the token from Hive storage

      final response = await http.get(
        Uri.parse(questionUrl + categoryId),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the request headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['questions'] as List;
        return data.map((json) => Question.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}
