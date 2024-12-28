import 'package:bus_app/components/confirm_button.dart';
import 'package:bus_app/components/custom_text_form_field.dart';
import 'package:bus_app/controllers/public_method.dart';
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
            getDetails: false,
          );
    }
    if (!mounted) throw Exception();

    if (context.read<BusInfoCubit>().state.busInfo != null) {
      searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    BusInfoCubit busCubit = context.watch<BusInfoCubit>();

    print(busCubit.state.busInfo?.toJson());

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
            body: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: [
                        Hero(
                          tag: widget.heroTag ?? '',
                          child: Image.asset('assets/images/test_1.avif'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            spacing: 12,
                            children: [
                              Text('버스 조회하세요'),
                              fieldRow(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Row fieldRow() {
    return Row(
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
    );
  }
}
