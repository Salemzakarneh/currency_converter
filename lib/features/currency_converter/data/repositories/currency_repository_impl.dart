import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/currencies.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_local_datasource.dart';
import '../datasources/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyLocalDataSource currencyLocalDataSource;
  final CurrencyRemoteDataSource currencyRemoteDataSource;

  CurrencyRepositoryImpl({
    required this.currencyLocalDataSource,
    required this.currencyRemoteDataSource,
  });

  @override
  Future<Either<Failure, Currencies>> getAllCurrencies() async {
    try {
      final currencies = await currencyRemoteDataSource.getAllCurrencies();
      currencyLocalDataSource.cacheCurrencies(currencies);
      return Right(currencies);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getOneCurrencyRate(
     {required String baseCurrency,required String targetCurrency}) async {
    try {
      final currencyRate = await currencyLocalDataSource.getOneCurrencyRate(
          baseCurrency: baseCurrency, targetCurrency: targetCurrency);
      return Right(currencyRate);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
