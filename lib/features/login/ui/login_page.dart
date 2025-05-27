import 'package:easy_date/assets.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:flutter_svg/svg.dart';

import '../../biometric/biometric.src.dart';

part 'login_widget.dart';

class LoginPage extends BaseGetWidget<LoginController> {
  const LoginPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return SDSSafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.ASSETS_IMAGES_PNG_CHAT_BACKGROUND_PNG),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildImageBackGroup(),
                    _buildAppName(),
                    AppDimens.vm16,
                    _buildInputEmail(controller),
                    AppDimens.vm16,
                    _buildInputPassword(controller),
                    AppDimens.vm24,
                    _buildLoginButton(controller),
                    AppDimens.vm16,
                    _buildForgotpassBtn(controller),
                    AppDimens.vm24,
                    _buildRegisterButton(controller),
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
