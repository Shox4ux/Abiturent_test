import '../enum.dart';

class TestModel {
  final String question;
  final List<TestOptionModel> options;

  const TestModel({
    required this.question,
    required this.options,
  });
}

class TestOptionModel {
  final String optionText;
  final TestVertions status;
  TestOptionModel({
    required this.optionText,
    required this.status,
  });
}
