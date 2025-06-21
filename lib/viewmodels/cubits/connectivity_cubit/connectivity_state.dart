part of 'connectivity_cubit.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityState extends Equatable {
  final ConnectivityStatus status;

  const ConnectivityState(this.status);

  @override
  List<Object?> get props => [status];

  ConnectivityState copyWith({ConnectivityStatus? status}) {
    return ConnectivityState(status ?? this.status);
  }
}
