
import 'package:equatable/equatable.dart';



class Currencies extends Equatable{
  final int timestamp;
  final Map<String,dynamic> currencies;

  const Currencies({required this.timestamp,required this.currencies});
  
  @override
  List<Object?> get props => [timestamp, currencies];
  
}