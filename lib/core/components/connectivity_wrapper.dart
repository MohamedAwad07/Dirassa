import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/cubits/connectivity_cubit/connectivity_cubit.dart';
import '../../views/connection_error/connection_error_view.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final bool showErrorScreen;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.showErrorScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        // If connectivity checking is not available or there's an error,
        // show the main app content (assume connected)
        if (state.status == ConnectivityStatus.unknown) {
          return child;
        }

        // Show error screen only if explicitly requested and disconnected
        if (showErrorScreen &&
            state.status == ConnectivityStatus.disconnected) {
          return const ConnectionErrorView();
        }

        // Show the main app content
        return child;
      },
    );
  }
}
