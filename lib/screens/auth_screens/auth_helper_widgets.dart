import 'package:flutter/material.dart';
import 'package:video_chat/utils/meta_colors.dart';
import 'package:video_chat/utils/meta_styles.dart';
import 'package:video_chat/utils/validators.dart';

class AgreementWidget extends StatelessWidget {
  const AgreementWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "By Clicking on Login I agree to all the Terms and conditions and privacy policy.",
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: MetaColors.secondaryTextColor),
      ),
    );
  }
}

class SubtitleWidget extends StatelessWidget {
  const SubtitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            color: MetaColors.tertiaryTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 13),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
                  colors: [Colors.black, MetaColors.primaryColor])
              .createShader(bounds);
        },
        child: Text(
          title,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.loading = false,
    required this.handler,
    required this.label,
  }) : super(key: key);
  final VoidCallback handler;
  final String label;
  final bool? loading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [MetaColors.primaryColor, MetaColors.secondaryColor])),
        child: loading!
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : InkWell(
                onTap: handler,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget(
      {Key? key,
      required this.textController,
      this.enabled = true,
      required this.label,
      this.obscureText = false,
      required this.validator})
      : super(key: key);
  final String label;
  final TextEditingController textController;
  final bool? obscureText;
  final String? Function(String?) validator;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enabled,
        validator: validator,
        controller: textController,
        style: MetaStyles.labelStyle,
        cursorColor: Colors.black,
        obscureText: obscureText!,
        decoration: MetaStyles.formFieldDecoration(label),
      ),
    );
  }
}
