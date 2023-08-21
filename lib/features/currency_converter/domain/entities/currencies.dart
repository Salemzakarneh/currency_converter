
import 'package:equatable/equatable.dart';

import 'currency.dart';

class Currencies extends Equatable{
  final int timestamp;
  final List<Currency> currencies;

  const Currencies({required this.timestamp,required this.currencies});
  
  @override
  List<Object?> get props => [timestamp, currencies];
  
}