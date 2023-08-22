

import 'dart:convert';

import 'package:currency_converter/core/errors/exceptions.dart';
import 'package:currency_converter/core/util/consts.dart';
import 'package:currency_converter/core/util/currency_rate_calculator.dart';
import 'package:currency_converter/features/currency_converter/data/datasources/currency_local_datasource.dart';
import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/currency_reader.dart';



class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockCurrencyRateCalculator extends Mock implements CurrencyRateCalculator{}

void main() {
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  MockCurrencyRateCalculator mockCurrencyRateCalculator = MockCurrencyRateCalculator();
  
  late CurrencyLocalDataSourceImpl localDataSource;

  setUp(() {
    localDataSource = CurrencyLocalDataSourceImpl(mockSharedPreferences,mockCurrencyRateCalculator);
  });

  
  group("cacheCurrencyList", () { 
const CurrenciesModel testCurrenciesTobeCached = CurrenciesModel(timestamp: 1,currencies: {"EUR": 1.5, "USD": 1});
final encodedCurrencyList = jsonEncode(CurrenciesModel.toJson(testCurrenciesTobeCached));

test("Should call SharedPreferences to cache currencies", () async{
  //arrange
  when(() => mockSharedPreferences.setString(constCachedCurrencies, encodedCurrencyList))
      .thenAnswer((_) => Future.value(true));
  //act
  await localDataSource.cacheCurrencies(testCurrenciesTobeCached);
  //assert
  verify(() => mockSharedPreferences.setString(constCachedCurrencies, encodedCurrencyList));



});

  });
  group("getOneCurrencyRate", () { 
    const String testBaseCurrency = "USD";
    const String testTargetCurrency = "EUR";
    const double testCurrencyRate = 1.5;
test("Should return the cached currency rate when available", () async {
      //arrange
      when(() => mockSharedPreferences.getString(any<String>()))
          .thenReturn(fixture("cached_currencies.json"));
          when(() => mockCurrencyRateCalculator.currencyRateCalculator(
            baseCurrency: any(named: "baseCurrency"),
            targetCurrency: any(named: "targetCurrency"),
            jsonList: any(named: "jsonList"),
          )).thenReturn(testCurrencyRate);
//act
      final result = await localDataSource.getOneCurrencyRate(baseCurrency: testBaseCurrency,targetCurrency: testTargetCurrency);
//assert
      verify(() => mockSharedPreferences.getString(constCachedCurrencies));
      verify(() => mockCurrencyRateCalculator.currencyRateCalculator(
        baseCurrency: testBaseCurrency,
        targetCurrency: testTargetCurrency,
        jsonList: any(named: "jsonList"),

      ));
      expect(result, testCurrencyRate);
    });

test("Should throw a CacheException when there is not cached currency list", () async{
  //arrange
  when(() => mockSharedPreferences.getString(any<String>()))
      .thenReturn(null);
  //act
  final call = localDataSource.getOneCurrencyRate;
  //assert
  expect(() => call(baseCurrency: testBaseCurrency,targetCurrency: testTargetCurrency), throwsA(const TypeMatcher<CacheException>()));

});
  });
}
