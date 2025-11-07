import 'package:get/get.dart';

import '../../models/quiz_result_model.dart';


class ResultController extends GetxController {
  // Observable model instance
  var quizResult = QuizResultModel(
    courseName: 'HTML Course',
    progress: 0.25,
    completedQuestions: 4,
    questionsNo: 'Question 1',
    questionsTime: 'Time 1:59s',
    question: 'HTML Stands for?',
    totalQuestions: 20,
    timeInfo: '1:00',
  ).obs;

  // Update course progress (example method)
  void updateProgress(double newProgress) {
    quizResult.update((result) {
      if (result != null) {
        result.progress = newProgress;
      }
    });
  }

  // Update completed questions (example method)
  void updateCompletedQuestions(int newCount) {
    quizResult.update((result) {
      if (result != null) {
        result.completedQuestions = newCount;
      }
    });
  }
}
