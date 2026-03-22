extension NameConvert on String {
  bool get isPlural => (endsWith('s') && !endsWith('ss')) || endsWith('ies');

  String pluralize() {
    if (isPlural) return this;
    if (endsWith('y')) return '${substring(0, length - 1)}ies';
    return '${this}s';
  }

  String singularize() {
    if (endsWith('ies')) return '${substring(0, length - 3)}y';
    if (endsWith('s') && !endsWith('ss')) return substring(0, length - 1);

    return this;
  }
}
