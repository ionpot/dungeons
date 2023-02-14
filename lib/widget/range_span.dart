import 'package:dungeons/utility/range.dart';
import 'package:dungeons/widget/colors.dart';
import 'package:flutter/widgets.dart';

class RangeSpan extends TextSpan {
  RangeSpan(Range range, {bool max = false, TextStyle? style})
      : super(
          text: '${max ? range.max : range}',
          style: TextStyle(color: max ? green : null).merge(style),
        );
}
