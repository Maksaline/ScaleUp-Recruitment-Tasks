part of 'connectivity_bloc.dart';

sealed class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityOnline extends ConnectivityState {}

class ConnectivityOffline extends ConnectivityState {}