class QuizResultModel {
  String courseName;
  double progress;
  int completedQuestions;
  String questionsNo;
  String questionsTime;
  String question;
  int totalQuestions;
  String timeInfo;

  QuizResultModel({
    required this.courseName,
    required this.progress,
    required this.completedQuestions,
    required this.questionsNo,
    required this.questionsTime,
    required this.question,
    required this.totalQuestions,
    required this.timeInfo,
  });
}
