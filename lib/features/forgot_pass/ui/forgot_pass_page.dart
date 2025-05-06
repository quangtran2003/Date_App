import 'package:easy_date/assets.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/widgets/safearea.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../generated/locales.g.dart';
import '../../../utils/model/input_text_form_field_model.dart';
import '../../../utils/widgets/input_text_form.dart';
import '../../../utils/widgets/input_text_form_with_label.dart';
import '../../../utils/widgets/util_widget.dart';
import '../controller/controller_src.dart';

part 'forgot_pass_widget.dart';

class ForgotPassPage extends BaseGetWidget<ForgotPassController> {
  const ForgotPassPage({super.key});
  @override
  Widget buildWidgets(BuildContext context) {
    return SDSSafeArea(
      child: Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  
                  children: [
                    _buildImageBackGroud(),
                    AppDimens.vm16,
                    _buildInputEmail(controller),
                    AppDimens.vm16,
                    _buildResigerButton(controller),
                    _buildLoginButton(),
                    AppDimens.vm48,
                  ],
                ),
              ).paddingAll(AppDimens.paddingMedium),
            ),
          ),
        ),
      ),
    );
  }
}
