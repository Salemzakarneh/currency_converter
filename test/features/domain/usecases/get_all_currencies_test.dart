
import 'package:currency_converter/features/currency_converter/domain/entities/currencies.dart';
import 'package:currency_converter/features/currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/get_all_currencies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  final MockCurrencyRepository mockCurrencyRepository =
      MockCurrencyRepository();
  final GetAllCurrencies usecase = GetAllCurrencies(mockCurrencyRepository);
  const Currencies testCurrencyList = Currencies(timestamp: 1, currencies: [
    Currency(code: "EUR", rate: 1.5),
    Currency(code: "USD", rate: 1),
  ]);
  test("should return a list of currencies", () async {
    //arrange
    when(() => mockCurrencyRepository.getAllCurrencies())
        .thenAnswer((_) async => const Right(testCurrencyList));
    //act
    final result = await usecase();
    //assert
    expect(result, const Right(testCurrencyList));
    verify(() => mockCurrencyRepository.getAllCurrencies());
    verifyNoMoreInteractions(mockCurrencyRepository);
  });
}
