

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/currency_repository.dart';

class GetOneCurrencyRate {
  final CurrencyRepository _currencyRepository;

  GetOneCurrencyRate(this._currencyRepository);
 Future< Either<Failure, double>> call(
      String baseCurrency, String targetCurrency) {
    return _currencyRepository.getOneCurrencyRate(baseCurrency, targetCurrency);
  }
}