import '../../../../core/util/consts.dart';
import '../../domain/entities/currencies.dart';


class CurrenciesModel extends Currencies {
  const CurrenciesModel({
    required int timestamp,
    required Map<String, dynamic> currencies,
  }) : super(timestamp: timestamp, currencies: currencies);

  factory CurrenciesModel.fromJson(Map<String, dynamic> json) {
    final quotes = json["quotes"] as Map<String, dynamic>;
    final keys = quotes.keys;
    final currencies = { "USD":1.0,
      for (var key in keys)
      if(!excludedKeys.contains(key)) key.substring(3,6): (quotes[key] as num).toDouble()
        
    };
    return CurrenciesModel(
      timestamp: json["timestamp"],
      currencies: currencies ,
    );
  }
  static Map<String, dynamic> toJson(Currencies currencies) => {
        "timestamp": currencies.timestamp,
        "quotes": currencies.currencies,
      };
}
