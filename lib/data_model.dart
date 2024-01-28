class DataModel {
  List<dynamic> questions = [];
  List<dynamic> answers = [];

  DataModel(
    this.questions,
    this.answers,
  );

  DataModel.fromJson(Map<String, dynamic> json) {
    answers = json['answers'];
    questions = json['questions'];
  }
}
