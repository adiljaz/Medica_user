part of 'obscure_bloc.dart';

@immutable
sealed class ObscureEvent {}

 final   class ObscureCLick extends ObscureEvent{
   final  bool  obscure ;

  ObscureCLick({required this.obscure });
 }


