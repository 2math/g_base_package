import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:g_base_package/base/utils/extensions.dart';

import 'package:g_base_package/g_base_package.dart';


void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    // expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  test('hex', () async {
    String color = Color(0xFF3F3F3F).toHex(leadingHashSign: false);

    expect(color, 'ff3f3f3f');

    color = Color(0xFF3F3F3F).toHex();

    expect(color, '#ff3f3f3f');
  });
}
