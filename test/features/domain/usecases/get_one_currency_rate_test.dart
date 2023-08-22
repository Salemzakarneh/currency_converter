
import 'package:currency_converter/features/currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/features/currency_converter/domain/usecases/get_one_currency_rate.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

void main() {
  final MockCurrencyRepository mockCurrencyRepository =
      MockCurrencyRepository();
  final GetOneCurrencyRate usecase = GetOneCurrencyRate(mockCurrencyRepository);

  const double currencyRateTest = 0.5;
  const String baseCurrencyTest = 'EUR';
  const String targetCurrencyTest = 'USD';

  test('should return a currency rate', () async {
    //arrange
    when(() => mockCurrencyRepository.getOneCurrencyRate(
           baseCurrency: baseCurrencyTest,targetCurrency: targetCurrencyTest))
        .thenAnswer((_) async => const Right(currencyRateTest));
    //act
    final result = await usecase(baseCurrency: baseCurrencyTest,targetCurrency: targetCurrencyTest);
    //assert
    expect(result, const Right(currencyRateTest));
    verify(() => mockCurrencyRepository.getOneCurrencyRate(
      baseCurrency: baseCurrencyTest,targetCurrency: targetCurrencyTest));
    verifyNoMoreInteractions(mockCurrencyRepository);
  });
}
