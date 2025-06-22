import 'package:dirassa/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_colors.dart';
import '../../viewmodels/cubits/theme_cubit/theme_cubit.dart';

class ThemeToggle extends StatelessWidget {
  final double? iconSize;
  final bool showLabel;

  const ThemeToggle({super.key, this.iconSize = 28, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return BlocSelector<ThemeCubit, ThemeState, ThemeStatus>(
          selector: (state) => state.status,
          builder: (context, status) {
            final isLoading = status == ThemeStatus.loading;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showLabel) ...[
                  Text(
                    isDarkMode ? AppStrings.appMode : AppStrings.appModeLight,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                ],
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: child.key == const ValueKey('dark')
                        ? Tween<double>(begin: 1, end: 0.75).animate(animation)
                        : Tween<double>(begin: 0.75, end: 1).animate(animation),
                    child: child,
                  ),
                  child: isDarkMode
                      ? Icon(
                          Icons.dark_mode,
                          key: const ValueKey('dark'),
                          color: Colors.amber,
                          size: iconSize,
                        )
                      : Icon(
                          Icons.light_mode,
                          key: const ValueKey('light'),
                          color: Colors.blue,
                          size: iconSize,
                        ),
                ),
                const SizedBox(width: 8),
                Switch(
                  activeColor: AppColors.secondary,
                  value: isDarkMode,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
