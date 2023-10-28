bool isLabel(String t) {
  if (t == '+' ||
      t == '-' ||
      t == '÷' ||
      t == '×' ||
      t == '%' ||
      t == '⌫' ||
      t == 'C') {
    return true;
  }
  return false;
}