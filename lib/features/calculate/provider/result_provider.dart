import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../common/utils/is_label.dart';

class ResultProvider extends ChangeNotifier {
  String result = '0';
  int animationState = 0;
  int height = 10;

  Future<void> startAnimation()async{
    animationState = 1;
    notifyListeners();
    Future.delayed(
      const Duration(milliseconds: 10),
          () {
        height -= 100;
        notifyListeners();
      },
    );
  }

  void updateResult(String newResult) {
    result = newResult;
    notifyListeners();
  }

  String get getResult => result;

  reset() {
    result = '0';
    notifyListeners();
  }

  void calculateResult(List<String> text) {
    if (isLabel(text.last)) {
      text.removeLast();
    }
    String answer = text.join();
    answer = answer.replaceAll('(', '');
    answer = answer.replaceAll('×', '*');
    answer = answer.replaceAll('÷', '/');
    Parser p = Parser();
    Expression exp = p.parse(answer);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    
    if (eval % 1 == 0) {
      result = eval.round().toString();
    } else {
      result = eval.toString();
    }
    notifyListeners();
  }
}
