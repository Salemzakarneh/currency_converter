import 'dart:convert';

import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/currencies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/currency_reader.dart';

void main() {
  const CurrenciesModel testCurrencyList = CurrenciesModel(
      timestamp: 1692118263, currencies: {"EUR": 1.5, "USD": 1});

  test("should be a subclass of Currency", () async {
    expect(testCurrencyList, isA<Currencies>());
  });

  test("should return currencies model from a valid json", () async {
    //arrange
    final Map<String, dynamic> decodedCurrency =
        jsonDecode(fixture("test_currencies.json"));
    //act
    final result = CurrenciesModel.fromJson(decodedCurrency);
    //assert
    expect(result, testCurrencyList);
  });
  test("should return a valid json from currencies model", () async {
    //arrange

    //act
    final result = CurrenciesModel.toJson(testCurrencyList);
    final jsonMap = {
      "timestamp": 1692118263,
      "quotes": {"EUR": 1.5, "USD": 1}
    };
    //assert
    expect(result, jsonMap);
  });
}
