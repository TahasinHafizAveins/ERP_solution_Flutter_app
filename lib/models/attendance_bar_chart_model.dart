class AttendanceBarChartModel {
  String? id;
  String? title;
  Ranges? ranges;
  MainChart? mainChart;
  Option? options;
  FooterLeft? footerLeft;
  FooterLeft? footerRight;

  AttendanceBarChartModel({
    this.id,
    this.title,
    this.ranges,
    this.mainChart,
    this.options,
    this.footerLeft,
    this.footerRight,
  });

  AttendanceBarChartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    ranges = json['ranges'] != null ? Ranges.fromJson(json['ranges']) : null;
    mainChart = json['mainChart'] != null
        ? MainChart.fromJson(json['mainChart'])
        : null;
    options = json['options'] != null ? Option.fromJson(json['options']) : null;
    footerLeft = json['footerLeft'] != null
        ? FooterLeft.fromJson(json['footerLeft'])
        : null;
    footerRight = json['footerRight'] != null
        ? FooterLeft.fromJson(json['footerRight'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (ranges != null) {
      data['ranges'] = ranges!.toJson();
    }
    if (mainChart != null) {
      data['mainChart'] = mainChart!.toJson();
    }
    if (options != null) {
      data['options'] = options!.toJson();
    }
    if (footerLeft != null) {
      data['footerLeft'] = footerLeft!.toJson();
    }
    if (footerRight != null) {
      data['footerRight'] = footerRight!.toJson();
    }
    return data;
  }
}

class Ranges {
  String? tW;
  String? l2W;
  String? l1M;

  Ranges({this.tW, this.l2W, this.l1M});

  Ranges.fromJson(Map<String, dynamic> json) {
    tW = json['TW'];
    l2W = json['L2W'];
    l1M = json['L1M'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TW'] = tW;
    data['L2W'] = l2W;
    data['L1M'] = l1M;
    return data;
  }
}

class MainChart {
  TW? tW;
  TW? l2W;
  TW? l1M;

  MainChart({this.tW, this.l2W, this.l1M});

  MainChart.fromJson(Map<String, dynamic> json) {
    tW = json['TW'] != null ? TW.fromJson(json['TW']) : null;
    l2W = json['L2W'] != null ? TW.fromJson(json['L2W']) : null;
    l1M = json['L1M'] != null ? TW.fromJson(json['L1M']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tW != null) {
      data['TW'] = tW!.toJson();
    }
    if (l2W != null) {
      data['L2W'] = l2W!.toJson();
    }
    if (l1M != null) {
      data['L1M'] = l1M!.toJson();
    }
    return data;
  }
}

class TW {
  List<String>? labels;
  List<Datasets>? datasets;

  TW({this.labels, this.datasets});

  TW.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    if (json['datasets'] != null) {
      datasets = <Datasets>[];
      json['datasets'].forEach((v) {
        datasets!.add(Datasets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    if (datasets != null) {
      data['datasets'] = datasets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datasets {
  String? type;
  String? label;
  List<double>? data;
  String? backgroundColor;
  String? hoverBackgroundColor;

  Datasets({
    this.type,
    this.label,
    this.data,
    this.backgroundColor,
    this.hoverBackgroundColor,
  });

  Datasets.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    label = json['label'];
    data = (json['data'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList();
    backgroundColor = json['backgroundColor'];
    hoverBackgroundColor = json['hoverBackgroundColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['label'] = label;
    data['data'] = this.data;
    data['backgroundColor'] = backgroundColor;
    data['hoverBackgroundColor'] = hoverBackgroundColor;
    return data;
  }
}

class Option {
  bool? responsive;
  bool? maintainAspectRatio;
  Legend? legend;
  Tooltips? tooltips;
  Scales? scales;

  Option({
    this.responsive,
    this.maintainAspectRatio,
    this.legend,
    this.tooltips,
    this.scales,
  });

  Option.fromJson(Map<String, dynamic> json) {
    responsive = json['responsive'];
    maintainAspectRatio = json['maintainAspectRatio'];
    legend = json['legend'] != null ? Legend.fromJson(json['legend']) : null;
    tooltips = json['tooltips'] != null
        ? Tooltips.fromJson(json['tooltips'])
        : null;
    scales = json['scales'] != null ? Scales.fromJson(json['scales']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsive'] = responsive;
    data['maintainAspectRatio'] = maintainAspectRatio;
    if (legend != null) {
      data['legend'] = legend!.toJson();
    }
    if (tooltips != null) {
      data['tooltips'] = tooltips!.toJson();
    }
    if (scales != null) {
      data['scales'] = scales!.toJson();
    }
    return data;
  }
}

class Legend {
  bool? display;

  Legend({this.display});

  Legend.fromJson(Map<String, dynamic> json) {
    display = json['display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    return data;
  }
}

class Tooltips {
  String? mode;

  Tooltips({this.mode});

  Tooltips.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mode'] = mode;
    return data;
  }
}

class Scales {
  List<XAxes>? xAxes;
  List<YAxes>? yAxes;

  Scales({this.xAxes, this.yAxes});

  Scales.fromJson(Map<String, dynamic> json) {
    if (json['xAxes'] != null) {
      xAxes = <XAxes>[];
      json['xAxes'].forEach((v) {
        xAxes!.add(XAxes.fromJson(v));
      });
    }
    if (json['yAxes'] != null) {
      yAxes = <YAxes>[];
      json['yAxes'].forEach((v) {
        yAxes!.add(YAxes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (xAxes != null) {
      data['xAxes'] = xAxes!.map((v) => v.toJson()).toList();
    }
    if (yAxes != null) {
      data['yAxes'] = yAxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class XAxes {
  bool? stacked;
  bool? display;
  Legend? gridLines;

  XAxes({this.stacked, this.display, this.gridLines});

  XAxes.fromJson(Map<String, dynamic> json) {
    stacked = json['stacked'];
    display = json['display'];
    gridLines = json['gridLines'] != null
        ? Legend.fromJson(json['gridLines'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stacked'] = stacked;
    data['display'] = display;
    if (gridLines != null) {
      data['gridLines'] = gridLines!.toJson();
    }
    return data;
  }
}

class YAxes {
  bool? stacked;
  String? type;
  bool? display;
  String? position;
  Legend? gridLines;
  Labels? labels;
  Ticks? ticks;

  YAxes({
    this.stacked,
    this.type,
    this.display,
    this.position,
    this.gridLines,
    this.labels,
    this.ticks,
  });

  YAxes.fromJson(Map<String, dynamic> json) {
    stacked = json['stacked'];
    type = json['type'];
    display = json['display'];
    position = json['position'];
    gridLines = json['gridLines'] != null
        ? Legend.fromJson(json['gridLines'])
        : null;
    labels = json['labels'] != null ? Labels.fromJson(json['labels']) : null;
    ticks = json['ticks'] != null ? Ticks.fromJson(json['ticks']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stacked'] = stacked;
    data['type'] = type;
    data['display'] = display;
    data['position'] = position;
    if (gridLines != null) {
      data['gridLines'] = gridLines!.toJson();
    }
    if (labels != null) {
      data['labels'] = labels!.toJson();
    }
    if (ticks != null) {
      data['ticks'] = ticks!.toJson();
    }
    return data;
  }
}

class Labels {
  bool? show;

  Labels({this.show});

  Labels.fromJson(Map<String, dynamic> json) {
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['show'] = show;
    return data;
  }
}

class Ticks {
  bool? beginAtZero;

  Ticks({this.beginAtZero});

  Ticks.fromJson(Map<String, dynamic> json) {
    beginAtZero = json['beginAtZero'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beginAtZero'] = beginAtZero;
    return data;
  }
}

class FooterLeft {
  String? title;
  Count? count;

  FooterLeft({this.title, this.count});

  FooterLeft.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'] != null ? Count.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (count != null) {
      data['count'] = count!.toJson();
    }
    return data;
  }
}

class Count {
  double? tW;
  double? l2W;
  double? l1M;

  Count({this.tW, this.l2W, this.l1M});

  Count.fromJson(Map<String, dynamic> json) {
    tW = json['TW'];
    l2W = json['L2W'];
    l1M = json['L1M'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TW'] = tW;
    data['L2W'] = l2W;
    data['L1M'] = l1M;
    return data;
  }
}
