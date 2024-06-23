import 'dart:collection';

class Circularbuffer<T> {
  late int _maxSize;
  late Queue<T> values;

  int index = 0;

  Circularbuffer(int size) {
    _maxSize = size;
    values = Queue<T>();
  }

  pushValue(T newValue) {
    values.add(newValue);
    index++;
    if (index >= _maxSize) {
      index = 0;
    }
  }
}
