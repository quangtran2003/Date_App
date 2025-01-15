import 'package:easy_date/assets.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../../utils/model/input_text_form_field_model.dart';
import '../../../utils/widgets/input_text_form.dart';
import '../../../utils/widgets/input_text_form_with_label.dart';
import '../../../utils/widgets/util_widget.dart';
import '../controller/controller_src.dart';

part 'register_widget.dart';

class RegisterPage extends BaseGetWidget<RegisterController> {
  const RegisterPage({super.key});
  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.ASSETS_IMAGES_CHAT_BACKGROUND_PNG),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageBackGroud(),
                  AppDimens.vm16,
                  _buildInputEmail(controller),
                  AppDimens.vm16,
                  _buildInputPassword(controller),
                  AppDimens.vm16,
                  _buildInputConfirmPassword(controller),
                  AppDimens.vm24,
                  _buildResigerButton(controller),
                  AppDimens.vm24,
                  _buildLoginButton(controller),
                  AppDimens.vm48,
                ],
              ),
            ).paddingAll(AppDimens.paddingMedium),
          ),
        ),
      ),
    );
  }
}
