import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodels/cubits/connectivity_cubit/connectivity_cubit.dart';
import '../../core/utils/app_strings.dart';

class ConnectionErrorView extends StatefulWidget {
  const ConnectionErrorView({super.key});

  @override
  State<ConnectionErrorView> createState() => _ConnectionErrorViewState();
}

class _ConnectionErrorViewState extends State<ConnectionErrorView> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        // Automatically detect when connection is restored
        if (state.status == ConnectivityStatus.connected) {
          // Connection restored - show a brief success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text(AppStrings.connectionRestored)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: isLandscape ? 16.0 : 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Connection error icon
                        Container(
                          width: isLandscape ? 80 : 120,
                          height: isLandscape ? 80 : 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: isLandscape ? 40 : 60,
                            color: theme.colorScheme.error,
                          ),
                        ),

                        SizedBox(height: isLandscape ? 16 : 32),

                        // Error title
                        Text(
                          AppStrings.connectionErrorTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            fontSize: isLandscape ? 18 : null,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: isLandscape ? 8 : 16),

                        // Error description
                        Text(
                          AppStrings.connectionErrorBody,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: isLandscape ? 14 : null,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: isLandscape ? 24 : 40),

                        // Retry button
                        BlocBuilder<ConnectivityCubit, ConnectivityState>(
                          builder: (context, state) {
                            return ElevatedButton.icon(
                              onPressed:
                                  _isRetrying ||
                                      state.status ==
                                          ConnectivityStatus.connected
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isRetrying = true;
                                      });

                                      // Check connectivity
                                      await context
                                          .read<ConnectivityCubit>()
                                          .checkConnectivity();

                                      setState(() {
                                        _isRetrying = false;
                                      });
                                    },
                              icon: _isRetrying
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              theme.colorScheme.onPrimary,
                                            ),
                                      ),
                                    )
                                  : const Icon(Icons.refresh_rounded),
                              label: Text(
                                _isRetrying
                                    ? AppStrings.connectionErrorRetrying
                                    : AppStrings.connectionErrorRetry,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isLandscape ? 24 : 32,
                                  vertical: isLandscape ? 12 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: isLandscape ? 16 : 24),

                        // Connection status indicator
                        BlocBuilder<ConnectivityCubit, ConnectivityState>(
                          builder: (context, state) {
                            if (state.status == ConnectivityStatus.connected) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: isLandscape ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.wifi_rounded,
                                      size: isLandscape ? 14 : 16,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.connectionConnected,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isLandscape ? 12 : null,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
