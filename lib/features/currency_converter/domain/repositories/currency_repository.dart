import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/currencies.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, Currencies>> getAllCurrencies();
  Future<Either<Failure, double>> getOneCurrencyRate({
   required String baseCurrency,
    required String targetCurrency,}
  );
}
