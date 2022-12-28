import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/screens/auth_screens/auth_screens.dart';
import 'package:video_chat/screens/home_screen.dart';
import 'package:video_chat/utils/helper_widgets.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AuthFlowError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                // margin: EdgeInsets.only(top: kToolbarHeight),
                // padding: EdgeInsets.only(
                //    top: kToolbarHeight+5),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.fixed,
                dismissDirection: DismissDirection.horizontal,
                content: MessageWidget(
                  message: state.error,
                  isError: true,
                )));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                // margin: EdgeInsets.only(top: kToolbarHeight),
                // padding: EdgeInsets.only(
                //    top: kToolbarHeight+5),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.fixed,
                dismissDirection: DismissDirection.horizontal,
                content: MessageWidget(
                  message: state.error,
                  isError: true,
                )));
          }
          if (state is AuthPasswordResetEmailSent) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                elevation: 0,
                // margin: EdgeInsets.only(top: kToolbarHeight),
                // padding: EdgeInsets.only(
                //    top: kToolbarHeight+5),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.fixed,
                dismissDirection: DismissDirection.horizontal,
                content: MessageWidget(
                  message: state.message,
                  isError: false,
                )));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) return Loader();
          if (state is AuthLoggedIn || state is AuthUserDetailsPending)
            return HomeScreen(title: "Home");
          return AuthScreens();
        },
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
