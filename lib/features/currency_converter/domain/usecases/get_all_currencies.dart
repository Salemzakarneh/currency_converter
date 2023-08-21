import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/currencies.dart';
import '../repositories/currency_repository.dart';

class GetAllCurrencies {
  final CurrencyRepository _currencyRepository;

  GetAllCurrencies(this._currencyRepository);
  Future<Either<Failure, Currencies>> call() {
    return _currencyRepository.getAllCurrencies();
  }
}