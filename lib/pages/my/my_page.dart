import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/components/rounded_picture.dart';
import 'package:transit_seoul/providers/user_cubit/user_cubit.dart';
import 'package:transit_seoul/styles/style_text.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<void> googleLogin() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize();

      GoogleSignInAccount account = await signIn.authenticate();

      List<String> scopes = ['https://www.googleapis.com/auth/userinfo.email'];

      GoogleSignInServerAuthorization? serverAuth =
          await account.authorizationClient.authorizeServer(scopes);

      if (serverAuth?.serverAuthCode == null) {
        throw Exception('serverAuthCode is null');
      }

      if (!mounted) return;

      if (serverAuth?.serverAuthCode != null) {
        await context
            .read<UserCubit>()
            .getUserLogin(serverAuth!.serverAuthCode);
      } else {
        // google access token
        // GoogleSignInClientAuthorization? authorization =
        //     await account.authorizationClient.authorizationForScopes(scopes) ??
        //         await account.authorizationClient.authorizeScopes(scopes);
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state.status.isLoggedIn) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.userData?.userName ?? '회원'} 님, 안녕하세요',
                            ),
                            if (state.userData?.email != null)
                              Text(
                                state.userData!.email!,
                                style: StyleText.bodyMedium(context)?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                          ],
                        ),
                        if (state.userData?.picture != null)
                          RoundedPicture(
                            heroTag: 'my-picture-hero',
                            imageUrl: state.userData!.picture!,
                          ),
                      ],
                    ),
                  );
                } else if (state.status.isFailed) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConfirmButton(
                      onTap: () {
                        context.read<UserCubit>().getUserDataFromDb();
                      },
                      description: 'Reload Data',
                      preset: ConfirmButtonPreset.error,
                      prefixChild: Icon(Icons.login),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConfirmButton(
                      onTap: googleLogin,
                      description: 'Login with Google',
                      prefixChild: Icon(Icons.login),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
