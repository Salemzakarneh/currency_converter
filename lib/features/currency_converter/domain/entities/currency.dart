
import 'package:equatable/equatable.dart';

class Currency extends Equatable{
  final String code;
  final double rate;
  const Currency({required this.code, required this.rate});
  
  @override
  List<Object?> get props => [code, rate];
}