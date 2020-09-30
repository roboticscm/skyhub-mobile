part of lunar_calendar_converter;

class Lunar {
  int _lunarYear;
  int lunarMonth;
  int lunarDay;
  bool isLeap;

  static List<String> _lunarMonthList = [
    L10n.ofValue().january,
    L10n.ofValue().february,
    L10n.ofValue().march,
    L10n.ofValue().april,
    L10n.ofValue().may,
    L10n.ofValue().june,
    L10n.ofValue().july,
    L10n.ofValue().august,
    L10n.ofValue().september,
    L10n.ofValue().october,
    L10n.ofValue().november,
    L10n.ofValue().december,
  ];
  static List<String> _lunarDayList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];
  static List<String> _tiangan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];
  static List<String> _dizhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];

  Lunar({int lunarYear, int lunarMonth, int lunarDay, bool isLeap}) {
    this.lunarYear = lunarYear;
    this.lunarMonth = lunarMonth;
    this.lunarDay = lunarDay;
    this.isLeap = isLeap == null ? false : isLeap;
  }

  set lunarYear(int v) {
    if (v == 0) {
      //规定公元 0 年即公元前 1 年
      v = -1;
    }
    _lunarYear = v;
  }

  int get lunarYear => _lunarYear;

  @override
  String toString() {
    String result = "";
    if (lunarYear != null) {
      int year = lunarYear;
      if (year < 0) {
        year++;
      }
      if (year < 1900) {
        year += ((2018 - year) / 60).floor() * 60;
      }
      int absYear = lunarYear.abs();
      String prefix = (lunarYear < 0 ? "BC" : "") + "$absYear";
      result += ((_tiangan[(year - 4) % _tiangan.length]) + (_dizhi[(year - 4) % _dizhi.length]) + "${L10n.ofValue().year} ($prefix)");
    }
    if (lunarMonth != null) {
      if (lunarMonth < 1 || lunarMonth > 12) {
        return L10n.ofValue().invalidateDate;
      }
      String month = _lunarMonthList[lunarMonth - 1];
      String leap = isLeap ? L10n.ofValue().leap : "";
      result += "$leap$month /";

      if (lunarDay != null) {
        if (lunarDay < 1 || lunarDay > 30) {
          return L10n.ofValue().invalidateDate;
        }
        result += _lunarDayList[lunarDay - 1];
      }
    }
    return result.isEmpty ? L10n.ofValue().invalidateDate : result;
  }
}
