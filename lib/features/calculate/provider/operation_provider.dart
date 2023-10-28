import 'package:calculator/common/widgets/custom_snackbar.dart';
import 'package:calculator/features/calculate/provider/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/is_label.dart';

class OperationProvider extends ChangeNotifier {
  List<String> text = ['0'];

  void addToText(String newWord, BuildContext context) {
    if (text.length < 25) {
      if (text[0] == '0' && !isLabel(newWord)) {
        text[0] = newWord;
      } else {
        if (isLabel(text.last) && isLabel(newWord)) {
          text.last = newWord;
        } else {
          if (text[0] != '0') {
            text.add(newWord);
          }
        }
      }
      context.read<ResultProvider>().calculateResult(List.from(text));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          content: 'You can\'t enter more than 25 characters',
          context: context));
    }
  }

  void reset(BuildContext context) {
    text.clear();
    text.add('0');
    context.read<ResultProvider>().reset();
    notifyListeners();
  }

  void delete() {
    if (text.length == 1) {
      text[0] = '0';
    } else {
      text.removeLast();
    }
    notifyListeners();
  }

  Future<void> checkLabel(String label, BuildContext context) async {
    if (label == '=') {
      text.clear();
      text.add(context.read<ResultProvider>().getResult);
      context.read<ResultProvider>().reset();
      notifyListeners();
    } else if (label == '⌫') {
      delete();
      context.read<ResultProvider>().calculateResult(List.from(text));
    } else if (label == '±') {
      if (!showResult() && text[0] != '0') {
        if (text[0] == '(-') {
          text.removeAt(0);
        } else {
          text.add(text[text.length - 1]);
          for (int i = text.length - 1; i > 0; i--) {
            text[i] = text[i - 1];
          }
          text[0] = '(-';
        }
      } else {
        for (int i = text.length - 1; i >= 0; i--) {
          if (i == 1 || isLabel(text[i])) {
            text.add(text[text.length - 1]);
            for (int j = text.length - 2; j > i + 1; j--) {
              text[j] = text[j - 1];
            }
            text[i + 1] = '(-';
            break;
          } else if (text[i] == '(-') {
            text.removeAt(i);
            break;
          }
        }
      }
      context.read<ResultProvider>().calculateResult(List.from(text));
      notifyListeners();
    } else if (label == 'C') {
      reset(context);
    }
  }

  bool showResult() {
    int i = 0;
    for (var element in text) {
      if (isLabel(element) && text.length - 1 > i) {
        return true;
      }
      i++;
    }
    return false;
  }
}
