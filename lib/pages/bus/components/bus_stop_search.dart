import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit_seoul/components/custom_search_bar.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';
import 'package:transit_seoul/enums/color_type.dart';
import 'package:transit_seoul/models/bus/bus_station_list.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class BusStopSearch extends StatefulWidget {
  const BusStopSearch({
    super.key,
    required this.searchText,
  });

  final ValueNotifier<String> searchText;

  @override
  State<BusStopSearch> createState() => _BusStopSearchState();
}

class _BusStopSearchState extends State<BusStopSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void validateSearch() {
    if (_formKey.currentState!.validate()) {
      widget.searchText.value = textController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    List<StationListItem> stationList =
        busCubit.state.stationList?.msgBody.itemList ?? [];

    if (!busCubit.state.status.isSuccess && !busCubit.state.status.isRefresh) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: busCubit.state.status.isSuccess && stationList.isEmpty
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: CustomSearchBar(
              buttonBgColor: StyleText.getColorContainer(
                context,
                colorType: ColorType.secondary,
              ),
              textFormField: CustomTextFormField(
                hintText: '정류장 검색...',
                borderColor: Theme.of(context).colorScheme.onInverseSurface,
                controller: textController,
                textInputAction: TextInputAction.done,
              ),
              onTapSearch: validateSearch,
            ),
          ),
        ),
      ),
    );
  }
}
