import 'package:easy_date/assets.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/model/input_text_form_field_model.dart';
import 'package:easy_date/utils/widgets/input_text_form.dart';
import 'package:easy_date/utils/widgets/input_text_form_with_label.dart';
import 'package:easy_date/utils/widgets/util_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

part 'login_widget.dart';

class LoginPage extends BaseGetWidget<LoginController> {
  const LoginPage({super.key});

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
                  _buildImageBackGroup(),
                  _buildAppName(),
                  AppDimens.vm16,
                  _buildInputEmail(controller),
                  AppDimens.vm16,
                  _buildInputPassword(controller),
                  AppDimens.vm24,
                  _buildLoginButton(controller),
                  AppDimens.vm24,
                  _buildRegisterButton(controller),
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
