class DeviceDimensions {
  final double parentWidth = 70.0;
  final double parentHeight = 110.0;
}

class RelativeBox {
  double left;
  double top;
  double width;
  double height;

  RelativeBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

class DigitData with DeviceDimensions {
  bool hasTwo;
  RelativeBox box1;
  RelativeBox? box2;

  DigitData({
    required this.hasTwo,
    required this.box1,
    this.box2,
  });

  List get box1LTWH {
    List<double> absoluteLTWH = List.filled(4, 0.0);
    absoluteLTWH[0] = box1.left * parentWidth;
    absoluteLTWH[1] = box1.top * parentHeight;
    absoluteLTWH[2] = box1.width * parentWidth;
    absoluteLTWH[3] = box1.height * parentHeight;
    return (absoluteLTWH);
  }

  List get box2LTWH {
    List<double> absoluteLTWH = List.filled(4, 0.0);
    absoluteLTWH[0] = box2?.left ?? 0 * parentWidth;
    absoluteLTWH[1] = box2?.top ?? 0 * parentHeight;
    absoluteLTWH[2] = box2?.width ?? 0 * parentWidth;
    absoluteLTWH[3] = box2?.height ?? 0 * parentHeight;
    return (absoluteLTWH);
  }
}

class ListOfDigitData {
  get digits => _digits;

  final List<DigitData> _digits = [
    // 0
    DigitData(
      hasTwo: false,
      box1: RelativeBox(left: 0.3, top: 0.2, width: 0.4, height: 0.6),
    ),
    // 1
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.0, top: 0.0, width: 0.35, height: 1.0),
      box2: RelativeBox(left: 0.65, top: 0.0, width: 0.35, height: 1.0),
    ),
    // 2
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.0, top: 0.2, width: 0.7, height: 0.2),
      box2: RelativeBox(left: 0.3, top: 0.6, width: 0.7, height: 0.2),
    ),
    // 3
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.0, top: 0.2, width: 0.7, height: 0.2),
      box2: RelativeBox(left: 0.0, top: 0.6, width: 0.7, height: 0.2),
    ),
    // 4
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.3, top: 0.0, width: 0.4, height: 0.4),
      box2: RelativeBox(left: 0.0, top: 0.6, width: 0.7, height: 0.4),
    ),
    // 5
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.3, top: 0.2, width: 0.7, height: 0.2),
      box2: RelativeBox(left: 0.0, top: 0.6, width: 0.7, height: 0.2),
    ),
    // 6
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.3, top: 0.2, width: 0.7, height: 0.2),
      box2: RelativeBox(left: 0.3, top: 0.6, width: 0.4, height: 0.2),
    ),
    // 7
    DigitData(
      hasTwo: false,
      box1: RelativeBox(left: 0.0, top: 0.2, width: 0.7, height: 0.8),
    ),
    // 8
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.3, top: 0.2, width: 0.4, height: 0.2),
      box2: RelativeBox(left: 0.3, top: 0.6, width: 0.4, height: 0.2),
    ),
    // 9
    DigitData(
      hasTwo: true,
      box1: RelativeBox(left: 0.3, top: 0.2, width: 0.4, height: 0.2),
      box2: RelativeBox(left: 0.0, top: 0.6, width: 0.7, height: 0.2),
    ),
  ];
}
