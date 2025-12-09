part of 'connectivity_bloc.dart';


sealed class ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  ConnectivityChanged(this.isConnected);
}

class CheckConnectivity extends ConnectivityEvent {}