import 'package:gap/gap.dart';
import 'package:transit_seoul/enums/theme_enum.dart';
import 'package:transit_seoul/providers/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsCubit settingsCubit = context.watch<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                themeSettings(context, settingsCubit),
                Gap(12),
                mapControl(context, settingsCubit),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget themeSettings(
    BuildContext context,
    SettingsCubit settingsCubit,
  ) {
    final ThemeEnum activeTheme = settingsCubit.state.isDarkTheme;

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

  Widget mapControl(
    BuildContext context,
    SettingsCubit settingsCubit,
  ) {
    final bool isMapControl = settingsCubit.state.isMapControl;

    return Row(
      children: [
        Text('지도 제어 도구 활성화'),
        Spacer(),
        SegmentedButton(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: false,
              label: Text('끄기'),
            ),
            ButtonSegment(
              value: true,
              label: Text('켜기'),
            ),
          ],
          selected: {isMapControl},
          onSelectionChanged: (Set<bool> value) {
            context.read<SettingsCubit>().switchMapControl(entry: value.first);
          },
        ),
      ],
    );
  }
}
