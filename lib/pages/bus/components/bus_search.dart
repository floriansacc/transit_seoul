import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit_seoul/components/custom_search_bar.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';
import 'package:transit_seoul/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:transit_seoul/providers/map_point_cubit/map_point_cubit.dart';

class BusSearch extends StatefulWidget {
  const BusSearch({
    super.key,
    required this.shouldDrawLine,
    this.focusNode,
    required this.isModal,
  });

  final ValueNotifier<bool> shouldDrawLine;
  final FocusNode? focusNode;
  final bool isModal;

  @override
  State<BusSearch> createState() => _BusSearchState();
}

class _BusSearchState extends State<BusSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> validateSearch(BuildContext context) async {
    widget.shouldDrawLine.value = false;
    BusInfoCubit busCubit = context.read<BusInfoCubit>();
    if (_formKey.currentState!.validate()) {
      await busCubit.getBusRouteInfo(
        int.parse(searchController.value.text),
        getDetails: true,
      );
      if (!context.mounted) throw Exception();

      await context.read<MapPointCubit>().addBusPositon(context);
      if (busCubit.state.status.isSuccess) {
        widget.shouldDrawLine.value = true;
      }
    }
    if (!mounted) throw Exception();

    if (busCubit.state.status.isSuccess) {
      searchController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (widget.isModal) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CustomSearchBar(
          textFormField: CustomTextFormField(
            focusNode: widget.focusNode,
            controller: searchController,
            hintText: '버스 번호...',
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
          onTapSearch: () async => validateSearch(context),
        ),
      ),
    );
  }
}
