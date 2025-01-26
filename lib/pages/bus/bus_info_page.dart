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

  final ValueNotifier<bool> shouldDrawLine = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMapFullScreen = ValueNotifier<bool>(false);

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
  }

  @override
  void dispose() {
    shouldDrawLine.dispose();
    searchFocusNode.dispose();
    isMapFullScreen.dispose();
    displayActions.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void openSearchModal() {
    PublicMethod.dialog(
      context,
      isDismis: false,
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
    // print(busCubit.state.busInfo?.msgBody.itemList.first.toJson());
    // print(busCubit.state.routePath?.msgBody.itemList.first.toJson());
    // print(busCubit.state.stationList?.msgBody.itemList.first.toJson());

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
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
              ],
              scrolledUnderElevation: 10,
            ),
            body: ValueListenableBuilder(
              valueListenable: isMapFullScreen,
              builder: (context, isFullScreen, child) => SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  spacing: 16,
                  children: [
                    if (!isFullScreen) ...[
                      BusSearch(
                        shouldDrawLine: shouldDrawLine,
                        focusNode: searchFocusNode,
                      ),
                      // Hero(
                      //   tag: widget.heroTag ?? '',
                      //   child: Image.asset('assets/images/test_1.avif'),
                      // ),
                    ],
                    BusMap(
                      shouldDrawLine: shouldDrawLine,
                      isMapFullScreen: isMapFullScreen,
                    ),
                    Column(
                      children: [
                        if (!isFullScreen) ...[
                          BusDetails(),
                          BusStopList(),
                          Gap(150),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // PublicMethod.nextButtonIosKeyboard(
        //   context,
        //   displayCondition: searchFocusNode.hasFocus,
        //   onTapFuction: () => FocusManager.instance.primaryFocus?.unfocus(),
        //   buttonText: '닫기',
        // ),
      ],
    );
  }
}
