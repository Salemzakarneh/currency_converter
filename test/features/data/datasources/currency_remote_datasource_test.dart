import 'dart:convert';
import 'package:currency_converter/core/errors/exceptions.dart';
import 'package:currency_converter/core/util/consts.dart';
import 'package:currency_converter/features/currency_converter/data/datasources/currency_remote_datasource.dart';
import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/currency_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final MockHttpClient mockHttpClient = MockHttpClient();
  CurrencyRemoteDataSourceImpl remoteDataSource =
      CurrencyRemoteDataSourceImpl(client: mockHttpClient);
  group("getAllCurrencies", () {
    final testJsonData = jsonDecode(fixture("test_currencies_remote.json"));
    final testCurrencies = CurrenciesModel.fromJson(testJsonData);

    test("should perform a get request on a URL", () async {
      //arrange
      when(() => mockHttpClient.get(Uri.parse(
              "http://apilayer.net/api/live?access_key=$acessKey&currencies=&source=USD&format=1")))
          .thenAnswer(
              (_) async => http.Response(fixture("test_currencies_remote.json"), 200));
      //act
      await remoteDataSource.getAllCurrencies();
      //assert
      verify(() => mockHttpClient.get(Uri.parse(
          "http://apilayer.net/api/live?access_key=$acessKey&currencies=&source=USD&format=1")));
    });

    test("should return a list of currencies when the response code is 200",
        () async {
      //arrange
      when(() => mockHttpClient.get(Uri.parse(
              "http://apilayer.net/api/live?access_key=$acessKey&currencies=&source=USD&format=1")))
          .thenAnswer(
              (_) async => http.Response(fixture("test_currencies_remote.json"), 200));
      //act
      final result = await remoteDataSource.getAllCurrencies();
      //assert
      expect(result, equals(testCurrencies));
    });
    test("should throw a ServerException when the response code is not 200",
        () async {
      //arrange
      when(() => mockHttpClient.get(Uri.parse(
              "http://apilayer.net/api/live?access_key=$acessKey&currencies=&source=USD&format=1")))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      //act
      final call = remoteDataSource.getAllCurrencies;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
