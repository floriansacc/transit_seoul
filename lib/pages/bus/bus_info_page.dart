import 'package:bus_app/components/confirm_button.dart';
import 'package:bus_app/components/custom_text_form_field.dart';
import 'package:bus_app/controllers/public_method.dart';
import 'package:bus_app/pages/bus/bus_details.dart';
import 'package:bus_app/providers/bus_info_cubit/bus_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> validateSearch() async {
    if (_formKey.currentState!.validate()) {
      await context.read<BusInfoCubit>().getBusRouteInfo(
            int.parse(searchController.value.text),
            getDetails: true,
          );
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

    print(busCubit.state.busId?.toJson());
    print(busCubit.state.busInfo?.msgBody.itemList.first.toJson());
    print(busCubit.state.routePath?.msgBody.itemList.first.toJson());
    print(busCubit.state.stationList?.msgBody.itemList.first.toJson());

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Bus Info',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  Hero(
                    tag: widget.heroTag ?? '',
                    child: Image.asset('assets/images/test_1.avif'),
                  ),
                  fieldRow(),
                  BusDetails(),
                ],
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Flexible(
                  flex: 3,
                  child: CustomTextFormField(
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
                ),
                Flexible(
                  child: ConfirmButton(
                    height: 55,
                    description: '검색',
                    onTap: () async => validateSearch(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
