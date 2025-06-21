import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityCubit()
    : super(const ConnectivityState(ConnectivityStatus.unknown)) {
    _initConnectivity();
    _setupConnectivityStream();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      // Handle MissingPluginException or other errors gracefully
      emit(
        const ConnectivityState(ConnectivityStatus.connected),
      ); // Assume connected by default
    }
  }

  void _setupConnectivityStream() {
    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          _updateConnectivityStatus(result);
        },
        onError: (error) {
          // Handle stream errors gracefully
          emit(
            const ConnectivityState(ConnectivityStatus.connected),
          ); // Assume connected
        },
      );
    } catch (e) {
      // Handle MissingPluginException for stream setup
      emit(
        const ConnectivityState(ConnectivityStatus.connected),
      ); // Assume connected
    }
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    ConnectivityStatus status;

    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        status = ConnectivityStatus.connected;
        break;
      case ConnectivityResult.none:
        status = ConnectivityStatus.disconnected;
        break;
      default:
        status = ConnectivityStatus.unknown;
    }

    emit(ConnectivityState(status));
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(result);
      return state.status == ConnectivityStatus.connected;
    } catch (e) {
      // Handle MissingPluginException or other errors
      emit(
        const ConnectivityState(ConnectivityStatus.connected),
      ); // Assume connected
      return true;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
