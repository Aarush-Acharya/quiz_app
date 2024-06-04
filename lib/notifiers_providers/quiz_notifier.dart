import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/notifiers_providers/auth_provider.dart';

class Question {
  const Question({
    required this.question,
    required this.id,
    required this.options,
    required this.ans,
    required this.marks,
  });

  factory Question.fromJson(Map<String, dynamic> map) {
    List<String> options = (map['options'] as List<dynamic>).map((option) {
      return option as String;
    }).toList();
    return Question(
      question: map['question'] as String,
      id: map['_id'] as String,
      options: options,
      ans: map['ans'] as String,
      marks: map['marks'] as int,
    );
  }

  // All properties should be `final` on our class.
  final String question;
  final String id;
  final List<String> options;
  final String ans;
  final int marks;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'question': question,
        '_id': id,
        'options': options,
        'ans': ans,
        'marks': marks,
      };
}

class Quiz {
  const Quiz({
    required this.name,
    required this.description,
    required this.author,
    required this.questions,
    required this.duration,
    required this.isComplete,
  });

  factory Quiz.fromJson(Map<String, dynamic> map) {
    var questions = (map['questions'] as List<dynamic>)
        .map((ques) => ques as Map<String, dynamic>)
        .toList();

    return Quiz(
        name: map['name'] as String,
        description: map['description'] as String,
        author: map['author'] as String,
        questions: questions.map(Question.fromJson).toList(),
        duration: map['duration'] as int,
        isComplete: map['isComplete'] as bool);
  }

  final String name;
  final String description;
  final String author;
  final List<Question> questions;
  final int duration;
  final bool isComplete;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
        'author': author,
        'questions': questions,
        'duration': duration,
        'isComplete': isComplete
      };
}

class AsyncQuizzesNotifier extends AsyncNotifier<List<Quiz>> {
  Future<List<Quiz>> _fetchQuizzes() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://quiz-app-backend-s6uc.onrender.com/fetchQuizzes'));
    request.body = jsonEncode({
      "author": credential!.user.sub,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final quizzes =
          jsonDecode(await response.stream.bytesToString()) as List<dynamic>;
      // Cast each element in the list to a Map<String, dynamic>
      final quizList = quizzes.map((q) => q as Map<String, dynamic>).toList();
      // Use the mapped list to create a list of Quiz objects
      return quizList.map(Quiz.fromJson).toList();
    } else {
      print(response.reasonPhrase);
      return [];
    }
  }

  @override
  Future<List<Quiz>> build() async {
    // Load initial todo list from the remote repository
    return _fetchQuizzes();
  }

  Quiz getQuizByName(String name) {
    List<Quiz> quizzes = state.asData!.value;
    Quiz quiz = quizzes.firstWhere((quiz) => quiz.name == name);
    return quiz;
  }

  Future<void> refetchQuizzes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _fetchQuizzes();
    });
  }

  // Future<void> addTodo(Quiz quiz) async {
  //   // Set the state to loading
  //   state = const AsyncValue.loading();
  //   // Add the new todo and reload the todo list from the remote repository
  //   state = await AsyncValue.guard(() async {
  //     await http.post('api/todos', body: quiz.toJson());
  //     return _fetchQuizzes();
  //   });
  // }

  // Let's allow removing todos
  // Future<void> removeTodo(String todoId) async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(() async {
  //     await http.delete('api/todos/$todoId');
  //     return _fetchTodo();
  //   });
  // }

  // Let's mark a todo as completed
  // Future<void> toggle(String todoId) async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(() async {
  //     await http.patch(
  //       'api/todos/$todoId',
  //       <String, dynamic>{'completed': true},
  //     );
  //     return _fetchTodo();
  //   });
  // }
}

final asyncQuizzesProvider =
    AsyncNotifierProvider<AsyncQuizzesNotifier, List<Quiz>>(() {
  return AsyncQuizzesNotifier();
});
