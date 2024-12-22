import 'package:bus_app/enums/theme_enum.dart';
import 'package:bus_app/providers/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: themeSettings(context),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget themeSettings(BuildContext context) {
    final ThemeEnum activeTheme =
        context.watch<SettingsCubit>().state.isDarkTheme;

    return Column(
      spacing: 12,
      children: [
        Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        for (final e in ThemeEnum.values) ...[
          Row(
            children: [
              Text(e.name),
              Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => context.read<SettingsCubit>().switchTheme(e),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      color: e == activeTheme
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
