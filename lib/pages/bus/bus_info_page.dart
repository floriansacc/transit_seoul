import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/pages/bus/components/bus_details.dart';
import 'package:transit_seoul/pages/bus/components/bus_map.dart';
import 'package:transit_seoul/pages/bus/components/bus_search.dart';
import 'package:transit_seoul/pages/bus/components/bus_stop_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'dart:math' as math;

class BusInfoPage extends StatefulWidget {
  const BusInfoPage({
    super.key,
    this.heroTag,
  });

  final String? heroTag;

  @override
  State<BusInfoPage> createState() => _BusInfoPageState();
}

class _BusInfoPageState extends State<BusInfoPage> {
  final ScrollController scrollController = ScrollController();

  FocusNode searchFocusNode = FocusNode();

  final ValueNotifier<bool> displayActions = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMapStickyTop = ValueNotifier<bool>(true);

  final ValueNotifier<bool> shouldDrawLine = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMapFullScreen = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isZoomOnMap = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >= 56 && !displayActions.value) {
        displayActions.value = true;
      } else if (scrollController.offset < 56 && displayActions.value) {
        displayActions.value = false;
      }
    });

    isMapFullScreen.addListener(() {
      if (isMapFullScreen.value) {
        displayActions.value = false;
      }
    });
  }

  @override
  void dispose() {
    shouldDrawLine.dispose();
    searchFocusNode.dispose();
    isMapFullScreen.dispose();
    isZoomOnMap.dispose();
    displayActions.dispose();
    isMapStickyTop.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void openSearchModal() {
    PublicMethod.dialog(
      context,
      canDismiss: false,
      Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocProvider(
            create: (context) => MapPointCubit(),
            child: BusSearch(isModal: true, shouldDrawLine: shouldDrawLine),
          ),
          ConfirmButton(
            description: '닫기',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    print(busCubit.state.busId?.toJson());

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ValueListenableBuilder(
            valueListenable: isMapFullScreen,
            builder: (context, isFullScreen, child) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: isFullScreen
                  ? AppBar(
                      foregroundColor: Theme.of(context).primaryColorDark,
                      forceMaterialTransparency: true,
                      centerTitle: true,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      surfaceTintColor: Colors.transparent,
                    )
                  : null,
              body: SafeArea(
                top: !isFullScreen,
                bottom: false,
                left: false,
                right: false,
                child: CustomScrollView(
                  shrinkWrap: false,
                  controller: scrollController,
                  slivers: [
                    if (!isFullScreen) ...[
                      appBar(isFullScreen: isFullScreen),
                      SliverToBoxAdapter(
                        child: BusSearch(
                          isModal: false,
                          shouldDrawLine: shouldDrawLine,
                          focusNode: searchFocusNode,
                        ),
                      ),
                      SliverGap(16),
                    ],
                    ValueListenableBuilder(
                      valueListenable: isMapStickyTop,
                      builder: (context, isSticky, child) => SliverStickyHeader(
                        header: BusMap(
                          heroTag: widget.heroTag,
                          shouldDrawLine: shouldDrawLine,
                          isMapFullScreen: isMapFullScreen,
                          isZoomOnMap: isZoomOnMap,
                        ),
                        sticky: isSticky,
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Visibility(
                              visible: !isFullScreen,
                              maintainState: true,
                              child: Column(
                                spacing: 16,
                                children: [
                                  Gap(16),
                                  BusDetails(),
                                  BusStopList(isZoomOnMap: isZoomOnMap),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () =>
                    context.read<BusInfoCubit>().refreshBusPosition(),
                child: Icon(Icons.restore),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar appBar({required bool isFullScreen}) {
    return SliverAppBar(
      forceMaterialTransparency: isFullScreen,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      floating: true,
      pinned: isFullScreen,
      title: Text(
        '버스 노선 조회',
        style: StyleText.bodyLarge(context),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: displayActions,
          builder: (context, isDisplay, child) => AnimatedOpacity(
            opacity: isDisplay ? 1 : 0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: GestureDetector(
              onTap: openSearchModal,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isMapStickyTop,
          builder: (context, isSticky, child) => GestureDetector(
            onTap: () => isMapStickyTop.value = !isSticky,
            child: Stack(
              children: [
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.map,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                if (!isSticky)
                  Positioned(
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: math.pi / 4,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Theme.of(context).iconTheme.color,
                            ),
                            child: SizedBox(
                              width: 38,
                              height: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
      scrolledUnderElevation: 10,
    );
  }
}
