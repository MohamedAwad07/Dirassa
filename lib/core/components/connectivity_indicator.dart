import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/cubits/connectivity_cubit/connectivity_cubit.dart';

class ConnectivityIndicator extends StatelessWidget {
  final double size;
  final Color? connectedColor;
  final Color? disconnectedColor;

  const ConnectivityIndicator({
    super.key,
    this.size = 16,
    this.connectedColor,
    this.disconnectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        IconData icon;
        Color color;

        switch (state.status) {
          case ConnectivityStatus.connected:
            icon = Icons.wifi;
            color = connectedColor ?? Colors.green;
            break;
          case ConnectivityStatus.disconnected:
            icon = Icons.wifi_off;
            color = disconnectedColor ?? Colors.red.withValues(alpha: 0.7);
            break;
          case ConnectivityStatus.unknown:
            icon = Icons.help_outline;
            color = theme.colorScheme.onSurface.withValues(alpha: 0.6);
            break;
        }

        return Icon(icon, size: size, color: color);
      },
    );
  }
}
