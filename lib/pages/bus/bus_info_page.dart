import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/pages/bus/components/bus_details.dart';
import 'package:transit_seoul/pages/bus/components/bus_map.dart';
import 'package:transit_seoul/pages/bus/components/bus_search.dart';
import 'package:transit_seoul/pages/bus/components/bus_stop_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
          BusSearch(shouldDrawLine: shouldDrawLine),
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
          child: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: isMapFullScreen,
              builder: (context, isFullScreen, child) => SafeArea(
                top: true,
                bottom: false,
                left: false,
                right: false,
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: scrollController,
                  slivers: [
                    appBar(),
                    if (!isFullScreen)
                      SliverToBoxAdapter(
                        child: BusSearch(
                          shouldDrawLine: shouldDrawLine,
                          focusNode: searchFocusNode,
                        ),
                      ),
                    SliverGap(16),
                    ValueListenableBuilder(
                      valueListenable: isMapStickyTop,
                      builder: (context, isSticky, child) => SliverStickyHeader(
                        header: BusMap(
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
                                  // Hero(
                                  //   tag: widget.heroTag ?? '',
                                  //   child: Image.asset('assets/images/test_1.avif'),
                                  // ),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget appBar() {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      floating: true,
      pinned: false,
      toolbarHeight: 56,
      collapsedHeight: 60,
      title: Text(
        'Bus Info',
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
                padding: const EdgeInsets.all(8.0),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isSticky ? Icons.map : Icons.map_outlined,
                size: 30,
              ),
            ),
          ),
        ),
      ],
      scrolledUnderElevation: 10,
    );
  }
}
