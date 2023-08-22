import 'package:currency_converter/core/errors/exceptions.dart';
import 'package:currency_converter/core/errors/failures.dart';
import 'package:currency_converter/features/currency_converter/data/datasources/currency_local_datasource.dart';
import 'package:currency_converter/features/currency_converter/data/datasources/currency_remote_datasource.dart';
import 'package:currency_converter/features/currency_converter/data/models/currencies_model.dart';
import 'package:currency_converter/features/currency_converter/data/repositories/currency_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDatasource extends Mock implements CurrencyLocalDataSource {}

class MockRemoteDatasource extends Mock implements CurrencyRemoteDataSource {}

void main() {
  MockLocalDatasource mockLocalDatasource = MockLocalDatasource();
  MockRemoteDatasource mockRemoteDatasource = MockRemoteDatasource();
  CurrencyRepositoryImpl repository = CurrencyRepositoryImpl(
    currencyLocalDataSource: mockLocalDatasource,
    currencyRemoteDataSource: mockRemoteDatasource,
  );

  group("getAllCurrencies", () {
    const testCurrenciesModel =
        CurrenciesModel(timestamp: 1, currencies: {"EUR": 1.5, "USD": 1});
    test(
      'should return remote data when the call to remote date source is successfull',
      () async {
        //arrange
        when(() => mockRemoteDatasource.getAllCurrencies())
            .thenAnswer((_) async => testCurrenciesModel);
        when(() => mockLocalDatasource.cacheCurrencies(testCurrenciesModel))
            .thenAnswer((_) async {});
        //act
        final result = await repository.getAllCurrencies();
        //assert
        verify(() => mockRemoteDatasource.getAllCurrencies());
        expect(result, equals(const Right(testCurrenciesModel)));
      },
    );
    test(
      'should cache currencies when the call to remote date source is successfull',
      () async {
        //arrange
        when(() => mockRemoteDatasource.getAllCurrencies())
            .thenAnswer((_) async => testCurrenciesModel);
        when(() => mockLocalDatasource.cacheCurrencies(testCurrenciesModel))
            .thenAnswer((_) async {});
        //act
        await repository.getAllCurrencies();
        //assert
        verify(() => mockRemoteDatasource.getAllCurrencies());
        verify(() => mockLocalDatasource.cacheCurrencies(testCurrenciesModel));
      },
    );
    test(
      'should throw ServerException when the call to remote date source is unsuccessfull',
      () async {
        //arrange
        when(() => mockRemoteDatasource.getAllCurrencies())
            .thenThrow(ServerException());

        //act
        final result = await repository.getAllCurrencies();
        //assert
        verify(() => mockRemoteDatasource.getAllCurrencies());
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
  group("getOneCurrencyRate", () {
    const double testCurrencyRate = 1.5;

    test("Should return the cached currency rate when available", () async {
//arrange
      when(() => mockLocalDatasource.getOneCurrencyRate(
            baseCurrency: any(named: "baseCurrency"),
            targetCurrency: any(named: "targetCurrency"),
          )).thenAnswer((_) async => testCurrencyRate);
//act
      final result = await repository.getOneCurrencyRate(
        baseCurrency: "USD",
        targetCurrency: "EUR",
      );
//assert
      verify(() => mockLocalDatasource.getOneCurrencyRate(
            baseCurrency: "USD",
            targetCurrency: "EUR",
          ));
      expect(result, equals(const Right(testCurrencyRate)));
    });

    test("Should throw a CacheException when currency rates are not cached",
        () async {
//arrange
      when(() => mockLocalDatasource.getOneCurrencyRate(
            baseCurrency: any(named: "baseCurrency"),
            targetCurrency: any(named: "targetCurrency"),
          )).thenThrow(CacheException());
//act
      final result = await repository.getOneCurrencyRate(
          baseCurrency: "USD", targetCurrency: "EUR");
//assert
      verify(() => mockLocalDatasource.getOneCurrencyRate(
            baseCurrency: "USD",
            targetCurrency: "EUR",
      ));
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
