import 'package:flutter/material.dart';
import '../../core/const/const_src.dart';

import '../utils_src.dart';

class DataEmpty extends StatelessWidget {
  final String dataEmpty;
  const DataEmpty({
    super.key,
    this.dataEmpty = BaseWidgetStr.dataEmpty,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("Không có dữ liệu"),
          ),
          TextWidget.buildText(
            dataEmpty,
            color: AppColors.dsGray3,
          )
        ],
      ),
    );
  }
}
