

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/currency_repository.dart';

class GetOneCurrencyRate {
  final CurrencyRepository _currencyRepository;

  GetOneCurrencyRate(this._currencyRepository);
 Future< Either<Failure, double>> call(
      {required String baseCurrency,required String targetCurrency}) {
    return _currencyRepository.getOneCurrencyRate(baseCurrency:baseCurrency, targetCurrency:targetCurrency);
  }
}