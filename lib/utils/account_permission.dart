class AccountPermission {
  /**
    Hoá đơn
  */

  /// Tạo mới vé, id: 20
  bool canCreateInv = false;

  /// Chỉnh sửa vé, id: 21
  bool canEditInv = false;

  /// Xoá vé, id: 22
  bool canDeleteInv = false;

  /// xem chi tiết vé, id: 23
  bool canViewInv = false;

  /// Phát hành vé, id: 26
  bool canReleaseInvInList = false;

  /*
    Điều chỉnh 
  */

  /// Điều chỉnh vé tạo mới, id: 27
  bool canCreateAdjustInv = false;

  /*
    Thay thế
  */

  /// Thay thế vé tạo mới, id: 89
  bool canCreateReplaceInv = false;

  /*
    Huỷ
  */

  /// Huỷ vé đã chọn, id: 77
  bool canCancelInv = false;

  /*
    DownloadPdf
  */

  /// Tải Pdf, id: 61
  bool canDownloadPdf = false;

  /**
    Hàng hoá, dịch vụ
  */

  /// Danh sách hàng hoá, id: 4
  bool canSearchProd = false;

  /// Thêm mới hàng hoá, id: 5
  bool canAddProd = false;

  ///Sửa thông tin hàng hoá, id: 6
  bool canEditProd = false;

  /// Xoá hàng hoá, id: 7
  bool canDeleteProd = false;

  /**
    Khách hàng
  */
  /// Danh sách khách hàng, id: 42
  bool canSearchCus = false;

  /// Thêm mới khách hàng, id: 41
  bool canAddCus = false;

  ///Sửa thông tin khách hàng, id: 44
  bool canEditCus = false;

  /// Xoá khách hàng, id: 3
  bool canDeleteCus = false;

  /**
    Mở rộng
  */

  /// Thống kê: Tình hình sử dụng hóa đơn, id: 62
  bool canReport = false;

  void checkPermissionAcc(List<int> listPermission) {
    for (var element in listPermission) {
      switch (element) {
        case -1: // Quyền quản trị, quy ước: -1
          canCreateInv = canEditInv = canDeleteInv = canViewInv =
              canReleaseInvInList = canCreateAdjustInv = canCreateReplaceInv =
                  canCancelInv = canDownloadPdf = canSearchProd = canAddProd =
                      canEditProd = canDeleteProd = canSearchCus = canAddCus =
                          canEditCus = canDeleteCus = canReport = true;
          break;
        case 20:
          canCreateInv = true;
          break;
        case 21:
          canEditInv = true;
          break;
        case 22:
          canDeleteInv = true;
          break;
        case 23:
          canViewInv = true;
          break;
        case 26:
          canReleaseInvInList = true;
          break;
        case 27:
          canCreateAdjustInv = true;
          break;
        case 89:
          canCreateReplaceInv = true;
          break;
        case 77:
          canCancelInv = true;
          break;
        case 61:
          canDownloadPdf = true;
          break;
        case 4:
          canSearchProd = true;
          break;
        case 5:
          canAddProd = true;
          break;
        case 6:
          canEditProd = true;
          break;
        case 7:
          canDeleteProd = true;
          break;
        case 42:
          canSearchCus = true;
          break;
        case 41:
          canAddCus = true;
          break;
        case 44:
          canEditCus = true;
          break;
        case 3:
          canDeleteCus = true;
          break;
        case 62:
          canReport = true;
          break;
      }
    }
  }
}
