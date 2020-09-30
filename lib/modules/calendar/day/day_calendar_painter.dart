import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/common/util.dart';
import 'package:mobile/modules/calendar/model.dart';
import 'package:mobile/modules/calendar/cal_util.dart';
import 'package:mobile/modules/calendar/scalendar.dart';

class DayCalendarPainter extends StatefulWidget {
  final List<ScheduleView> list;
  final void Function(int) onSelected;
  final void Function(int, List<ScheduleView>) drawInvisibleItemCallback;
  final void Function(Offset offset) onTapCallback;
  final int selectedId;

  const DayCalendarPainter({
    Key key,
    @required this.drawInvisibleItemCallback,
    @required this.list,
    @required this.onSelected,
    @required this.onTapCallback,
    this.selectedId = -1,
  }) : super(key: key);

  @override
  _DayCalendarPainterState createState() => _DayCalendarPainterState();
}

class _DayCalendarPainterState extends State<DayCalendarPainter> {
  @override
  Widget build(BuildContext context) {
    _RectPainter _rectPainter = _RectPainter(widget.list, widget.selectedId, widget.drawInvisibleItemCallback);
    return GestureDetector(
      onTapUp: (details) {
        RenderBox box = context.findRenderObject();
        final offset = box.globalToLocal(details.globalPosition);

        widget.onTapCallback(offset);

        final id = widget.list?.lastWhere((item) => item.dayCoordinate.contains(offset), orElse: () => ScheduleView(scheduleItemId: -1))?.scheduleItemId;
        if (id != -1) {
          widget.onSelected(id);
          return;
        }
      },
      onLongPressStart: (details) {
        RenderBox box = context.findRenderObject();
        final offset = box.globalToLocal(details.globalPosition);

        widget.onTapCallback(offset);

        if (widget.list == null || widget.list.length == 0) {
          widget.onSelected(-1);
          return;
        }
        final id = widget.list?.lastWhere((item) => item.dayCoordinate.contains(offset), orElse: () => ScheduleView(scheduleItemId: -1))?.scheduleItemId;
        if (id == -1) {
          widget.onSelected(-1);
          return;
        }

      },
      child: CustomPaint(
        size: Size(Util.getScreenWidth(), CAL_ROW_HEIGHT*(24+1)),
        painter: _BasePainter(),
        foregroundPainter: _rectPainter,
      ),
    );
  }

}

class _RectPainter extends CustomPainter {
  static const double MAX_ITEM_WIDTH = 100;

  static Color _eventBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_EVENT);
  static Color _eventTextColor = CalUtil.getOpposingColor(_eventBgColor);
  static Paint _eventContentPaint = Paint()
    ..color = _eventBgColor;

  static Color _meetingBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_MEETING);
  static Color _meetingTextColor = CalUtil.getOpposingColor(_meetingBgColor);
  static Paint _meetingContentPaint = Paint()
    ..color = _meetingBgColor;

  static Color _taskBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TASK);
  static Color _taskTextColor = CalUtil.getOpposingColor(_taskBgColor);
  static Paint _taskContentPaint = Paint()
    ..color = _taskBgColor;


  static Color _reminderBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_REMINDER);
  static Color _reminderTextColor = CalUtil.getOpposingColor(_reminderBgColor);
  static Paint _reminderContentPaint = Paint()
    ..color = _reminderBgColor;

  static Color _travelingBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_TRAVELING);
  static Color _travelingTextColor = CalUtil.getOpposingColor(_travelingBgColor);
  static Paint _travelingContentPaint = Paint()
    ..color = _travelingBgColor;

  static Color _holidayBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_HOLIDAY);
  static Color _holidayTextColor = CalUtil.getOpposingColor(_holidayBgColor);
  static Paint _holidayContentPaint = Paint()
    ..color = _holidayBgColor;

  static Color _potentialBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_LEAD_ACTIVITY);
  static Color _potentialTextColor = CalUtil.getOpposingColor(_potentialBgColor);
  static Paint _potentialContentPaint = Paint()
    ..color = _potentialBgColor;

  static Color _oppertunityBgColor = CalUtil.getBackgroundColorByEventType(SCalendar.TYPE_OPPORTUNITY_ACTIVITY);
  static Color _oppertunityTextColor = CalUtil.getOpposingColor(_oppertunityBgColor);
  static Paint _oppertunityContentPaint = Paint()
    ..color = _oppertunityBgColor;

  static TextStyle _eventTextStyle = TextStyle(color: _eventTextColor);
  static TextStyle _meetingTextStyle = TextStyle(color: _meetingTextColor);
  static TextStyle _taskTextStyle = TextStyle(color: _taskTextColor);
  static TextStyle _reminderTextStyle = TextStyle(color: _reminderTextColor);
  static TextStyle _travelingTextStyle = TextStyle(color: _travelingTextColor);
  static TextStyle _holidayTextStyle = TextStyle(color: _holidayTextColor);
  static TextStyle _potentialTextStyle = TextStyle(color: _potentialTextColor);
  static TextStyle _oppertunityTextStyle = TextStyle(color: _oppertunityTextColor);

  final List<ScheduleView> list;
  final int selectedIndex;
  final void Function(int, List<ScheduleView>) drawInvisibleItemCallback;
  Map<int, Paint> _paints;
  Map<int, TextStyle> _textStyles;
  _RectPainter(this.list, this.selectedIndex, this.drawInvisibleItemCallback):
    _paints = Map()
      ..putIfAbsent(SCalendar.TYPE_EVENT, () => _eventContentPaint)
      ..putIfAbsent(SCalendar.TYPE_MEETING, () => _meetingContentPaint)
      ..putIfAbsent(SCalendar.TYPE_TASK, () => _taskContentPaint)
      ..putIfAbsent(SCalendar.TYPE_REMINDER, () => _reminderContentPaint)
      ..putIfAbsent(SCalendar.TYPE_TRAVELING, () => _travelingContentPaint)
      ..putIfAbsent(SCalendar.TYPE_HOLIDAY, () => _holidayContentPaint)
      ..putIfAbsent(SCalendar.TYPE_LEAD_ACTIVITY, () => _potentialContentPaint)
      ..putIfAbsent(SCalendar.TYPE_OPPORTUNITY_ACTIVITY, () => _oppertunityContentPaint)
    ,
    _textStyles = Map()
      ..putIfAbsent(SCalendar.TYPE_EVENT, () => _eventTextStyle)
      ..putIfAbsent(SCalendar.TYPE_MEETING, () => _meetingTextStyle)
      ..putIfAbsent(SCalendar.TYPE_TASK, () => _taskTextStyle)
      ..putIfAbsent(SCalendar.TYPE_REMINDER, () => _reminderTextStyle)
      ..putIfAbsent(SCalendar.TYPE_TRAVELING, () => _travelingTextStyle)
      ..putIfAbsent(SCalendar.TYPE_HOLIDAY, () => _holidayTextStyle)
      ..putIfAbsent(SCalendar.TYPE_LEAD_ACTIVITY, () => _potentialTextStyle)
      ..putIfAbsent(SCalendar.TYPE_OPPORTUNITY_ACTIVITY, () => _oppertunityTextStyle)
  ;

  @override
  void paint(Canvas canvas, Size size) {
    if(list == null)
      return;

    List<Rect> paintedRects = [];
    List<ScheduleView> invisibleList = [];

    for (ScheduleView s in list) {
      TextSpan span = TextSpan(style: _textStyles[s?.eventType ?? 0], text: '${s.title}');
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.ellipsis = "...";
      tp.layout();
      var oldTextWidth = tp.width + CAL_PADDING*2;
      var isRotated = _shouldRotate(s.dayCoordinate.height, oldTextWidth);
      if (isRotated) {
        s.dayCoordinate = CalUtil.reCalcLeftOfRect(paintedRects, s.dayCoordinate, CAL_PADDING*6);
        tp.layout(maxWidth: s.dayCoordinate.height - CAL_PADDING*2);
      } else {
        var itemWidth = min (oldTextWidth, MAX_ITEM_WIDTH);
        if (oldTextWidth > MAX_ITEM_WIDTH) {
          tp.maxLines = max(1, (s.dayCoordinate.height /tp.preferredLineHeight).floor());
          tp.maxLines = max(1, (s.dayCoordinate.height /tp.preferredLineHeight).floor());
          tp.layout(maxWidth: MAX_ITEM_WIDTH);
        }
        s.dayCoordinate = CalUtil.reCalcLeftOfRect(paintedRects, s.dayCoordinate, itemWidth);
      }

      if(s.dayCoordinate.left != -1){
        Rect rect = Rect.fromLTWH(s.dayCoordinate.left, s.dayCoordinate.top + CAL_PADDING-1, s.dayCoordinate.width, s.dayCoordinate.height-1);
        canvas.drawRect(rect, _paints[s?.eventType ?? 0]);
        if (isRotated) {
          canvas.save();
          canvas.translate(rect.left + CAL_PADDING, rect.top );
          canvas.rotate(pi / 2);
          tp.paint(canvas, Offset(CAL_PADDING, - rect.width / 2 - CAL_PADDING));
          canvas.restore();
        } else {
          tp.paint(canvas, Offset(rect.left + CAL_PADDING, rect.top));
        }
      } else {
        invisibleList.add(s);
      }
      paintedRects.add(s.dayCoordinate);
    }

    drawInvisibleItemCallback(_countInvisibleItem(), invisibleList);
  }

  bool _shouldRotate(double containerHeight, double contentWidth) {
    if (containerHeight > contentWidth || containerHeight > CAL_ROW_HEIGHT*4)
      return true;
    else
      return false;
  }

  int _countInvisibleItem() {
    if (list == null || list.length == 0)
      return 0;

    return list.where((item) => item.dayCoordinate.left == -1).length;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _BasePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.grey;

    var defaultTextStyle = TextStyle(color: Colors.black);
    for(var h = 0; h < 24; h++) {
      canvas.drawLine(Offset(CAL_PADDING, CAL_ROW_HEIGHT*(h+1) + CAL_PADDING), Offset(size.width, CAL_ROW_HEIGHT*(h+1) + CAL_PADDING), paint);
      TextSpan span = TextSpan(style: defaultTextStyle, text: '$h');
      TextPainter tp = new TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(CAL_PADDING, CAL_ROW_HEIGHT*(h) + CAL_DELTA));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}