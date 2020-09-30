import 'package:mobile/locale/locales.dart';

import 'holiday_model.dart';

class HolidayUtil {
  static String getHolidayTypeName(String code) {
    switch (code) {
      case "AN":
        return L10n.ofValue().annualLeave;
      case "AL":
        return L10n.ofValue().publicLeave;
      case "WD":
        return L10n.ofValue().marriedLeave;
      case "SK":
        return L10n.ofValue().sickLeave;
      case "FN":
        return L10n.ofValue().funeralLeave;
      case "MT":
        return L10n.ofValue().maternityLeave;
      case HolidayView.TYPE_PERSONAL_LEAVE:
        return L10n.ofValue().personalLeave;
      case "AC":
        return L10n.ofValue().injuryLeave;
      case "SP":
        return L10n.ofValue().specialLeave;
    }

    return code??'';
  }
}