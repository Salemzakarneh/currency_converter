

import 'dart:convert';

import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:http/http.dart'as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/consts.dart';

abstract class CurrencyRemoteDataSource {
  Future<CurrenciesModel> getAllCurrencies();
  
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<CurrenciesModel> getAllCurrencies() async {
    final response = await client.get(
        Uri.parse("http://apilayer.net/api/live?access_key=$acessKey&currencies=&source=USD&format=1"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final currencies = CurrenciesModel.fromJson(jsonData);
      return currencies;
    } else {
      throw ServerException();
    }
  }
}
