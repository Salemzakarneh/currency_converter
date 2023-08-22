class CurrencyRateCalculator{

 double currencyRateCalculator(
    {required String baseCurrency,
    required String targetCurrency,
    required dynamic jsonList}) {
  final base = (jsonList[baseCurrency] as num).toDouble();
  final target = (jsonList[targetCurrency] as num).toDouble();
  // Rounded to nearest 3 decimal
  final currencyRate = (((target / base) * 1000).round()) / 1000;
  return currencyRate;
}


}