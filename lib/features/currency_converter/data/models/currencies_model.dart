import '../../domain/entities/currencies.dart';


class CurrenciesModel extends Currencies {
  const CurrenciesModel({
    required int timestamp,
    required Map<String, dynamic> currencies,
  }) : super(timestamp: timestamp, currencies: currencies);

  factory CurrenciesModel.fromJson(Map<String, dynamic> json) {
    return CurrenciesModel(
      timestamp: json["timestamp"],
      currencies: json["quotes"] ,
    );
  }
  static Map<String, dynamic> toJson(Currencies currencies) => {
        "timestamp": currencies.timestamp,
        "quotes": currencies.currencies,
      };
}
