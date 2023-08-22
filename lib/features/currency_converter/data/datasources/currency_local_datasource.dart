import 'dart:convert';

import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/consts.dart';
import '../../../../core/util/currency_rate_calculator.dart';

abstract class CurrencyLocalDataSource {
  Future<void> cacheCurrencies(CurrenciesModel currenciesToCache);
  Future<double> getOneCurrencyRate({
    required String baseCurrency,
    required String targetCurrency,
  });
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final SharedPreferences sharedPreferences;
  final CurrencyRateCalculator currencyRateCalculator;

  CurrencyLocalDataSourceImpl(this.sharedPreferences,this.currencyRateCalculator);

  @override
  Future<void> cacheCurrencies(CurrenciesModel currenciesToCache) {
    final encodedCurrencyList =
        jsonEncode(CurrenciesModel.toJson(currenciesToCache));
    return sharedPreferences.setString(
        constCachedCurrencies, encodedCurrencyList);
  }

  @override
  Future<double> getOneCurrencyRate({
    required String baseCurrency,
    required String targetCurrency,
  }) {
    final cachedCurrencyList =
        sharedPreferences.getString(constCachedCurrencies);

    if (cachedCurrencyList != null) {
      final decodedCurrencyList = jsonDecode(cachedCurrencyList)["quotes"];
      final currencyRate = currencyRateCalculator.currencyRateCalculator(
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
        jsonList: decodedCurrencyList,
      );
      return Future.value(currencyRate);
    } else {
      throw CacheException();
    }
  }
}
