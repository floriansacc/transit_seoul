import 'package:transit_seoul/components/custom_search_bar.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/pages/bus/components/bus_details.dart';
import 'package:transit_seoul/pages/bus/components/bus_map.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final ValueNotifier<bool> shouldDrawLine = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isMapFullScreen = ValueNotifier<bool>(false);

  @override
  void dispose() {
    shouldDrawLine.dispose();
    isMapFullScreen.dispose();
    super.dispose();
  }

  Future<void> validateSearch() async {
    shouldDrawLine.value = false;
    BusInfoCubit busCubit = context.read<BusInfoCubit>();
    if (_formKey.currentState!.validate()) {
      await busCubit.getBusRouteInfo(
        int.parse(searchController.value.text),
        getDetails: true,
      );
      if (busCubit.state.status.isSuccess) {
        shouldDrawLine.value = true;
      }
    }
    if (!mounted) throw Exception();

    if (context.read<BusInfoCubit>().state.busInfo != null) {
      searchController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    // print(busCubit.state.busId?.toJson());
    print(busCubit.state.busInfo?.msgBody.itemList.first.toJson());
    // print(busCubit.state.routePath?.msgBody.itemList.first.toJson());
    print(busCubit.state.stationList?.msgBody.itemList.first.toJson());

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Bus Info',
                style: StyleText.bodyLarge(context),
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: isMapFullScreen,
              builder: (context, isFullScreen, child) => SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    if (!isFullScreen) ...[
                      Hero(
                        tag: widget.heroTag ?? '',
                        child: Image.asset('assets/images/test_1.avif'),
                      ),
                      fieldRow(),
                      BusDetails(),
                    ],
                    BusMap(
                      shouldDrawLine: shouldDrawLine,
                      isMapFullScreen: isMapFullScreen,
                    ),
                    Gap(isFullScreen ? 0 : 100),
                  ],
                ),
              ),
            ),
          ),
        ),
        PublicMethod.nextButtonIosKeyboard(
          context,
          displayCondition: searchFocusNode.hasFocus,
          onTapFuction: () => FocusScope.of(context).unfocus(),
          buttonText: '닫기',
        ),
      ],
    );
  }

  Padding fieldRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          children: [
            CustomSearchBar(
              textFormField: CustomTextFormField(
                focusNode: searchFocusNode,
                controller: searchController,
                hintText: '버스 번호',
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                masks: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChange: (_) {
                  if (searchController.text.length == 1) {
                    _formKey.currentState!.validate();
                  }
                },
                validator: (String? value) {
                  {
                    if (value == null || value.isEmpty) {
                      return '버스 번호를 입력하세요.';
                    }
                    return null;
                  }
                },
              ),
              onTapSearch: () async => validateSearch(),
            ),
          ],
        ),
      ),
    );
  }
}
