class Result {
  String? id;
  String? title;
  MainTable? table;
  Ranges? ranges;
  String? currentRange;
  MainChart? mainChart;
  List<Footer>? footer;
  String? fromDate;
  String? toDate;

  Result({
    this.id,
    this.title,
    this.table,
    this.ranges,
    this.currentRange,
    this.mainChart,
    this.footer,
    this.fromDate,
    this.toDate,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    table = json['table'] != null ? MainTable.fromJson(json['table']) : null;
    ranges = json['ranges'] != null ? Ranges.fromJson(json['ranges']) : null;
    currentRange = json['currentRange'];
    mainChart = json['mainChart'] != null
        ? MainChart.fromJson(json['mainChart'])
        : null;
    if (json['footer'] != null) {
      footer = <Footer>[];
      json['footer'].forEach((v) {
        footer!.add(Footer.fromJson(v));
      });
    }
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (table != null) {
      data['table'] = table!.toJson();
    }
    if (ranges != null) {
      data['ranges'] = ranges!.toJson();
    }
    data['currentRange'] = currentRange;
    if (mainChart != null) {
      data['mainChart'] = mainChart!.toJson();
    }
    if (footer != null) {
      data['footer'] = footer!.map((v) => v.toJson()).toList();
    }
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    return data;
  }
}

class MainTable {
  List<Columns>? columns;
  List<Rows>? rows;

  MainTable({this.columns, this.rows});

  MainTable.fromJson(Map<String, dynamic> json) {
    if (json['columns'] != null) {
      columns = <Columns>[];
      json['columns'].forEach((v) {
        columns!.add(Columns.fromJson(v));
      });
    }
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (columns != null) {
      data['columns'] = columns!.map((v) => v.toJson()).toList();
    }
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Columns {
  String? id;
  String? title;

  Columns({this.id, this.title});

  Columns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Rows {
  String? id;
  List<Cells>? cells;

  Rows({this.id, this.cells});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cells'] != null) {
      cells = <Cells>[];
      json['cells'].forEach((v) {
        cells!.add(Cells.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (cells != null) {
      data['cells'] = cells!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cells {
  String? id;
  String? value;
  String? classes;
  String? icon;

  Cells({this.id, this.value, this.classes, this.icon});

  Cells.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    classes = json['classes'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['classes'] = classes;
    data['icon'] = icon;
    return data;
  }
}

class MainChart {
  List<String>? labels;
  Datasets? datasets;
  Options? options;

  MainChart({this.labels, this.datasets, this.options});

  MainChart.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    datasets = json['datasets'] != null
        ? Datasets.fromJson(json['datasets'])
        : null;
    options = json['options'] != null
        ? Options.fromJson(json['options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    if (datasets != null) {
      data['datasets'] = datasets!.toJson();
    }
    if (options != null) {
      data['options'] = options!.toJson();
    }
    return data;
  }
}

class Datasets {
  List<LW>? lW;
  List<L2W>? l2W;
  List<L1M>? l1M;

  Datasets({this.lW, this.l2W, this.l1M});

  Datasets.fromJson(Map<String, dynamic> json) {
    if (json['LW'] != null) {
      lW = <LW>[];
      json['LW'].forEach((v) {
        lW!.add(LW.fromJson(v));
      });
    }
    if (json['L2W'] != null) {
      l2W = <L2W>[];
      json['L2W'].forEach((v) {
        l2W!.add(L2W.fromJson(v));
      });
    }
    if (json['L1M'] != null) {
      l1M = <L1M>[];
      json['L1M'].forEach((v) {
        l1M!.add(L1M.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lW != null) {
      data['LW'] = lW!.map((v) => v.toJson()).toList();
    }
    if (l2W != null) {
      data['L2W'] = l2W!.map((v) => v.toJson()).toList();
    }
    if (l1M != null) {
      data['L1M'] = l1M!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<dynamic>? operator [](String key) {
    switch (key) {
      case 'LW':
        return lW;
      case 'L2W':
        return l2W;
      case 'L1M':
        return l1M;
      default:
        return null;
    }
  }
}

class L2W {
  List<int>? data;
  List<String>? backgroundColor;
  List<String>? hoverBackgroundColor;

  L2W({this.data, this.backgroundColor, this.hoverBackgroundColor});

  L2W.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    backgroundColor = json['backgroundColor'].cast<String>();
    hoverBackgroundColor = json['hoverBackgroundColor'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['backgroundColor'] = backgroundColor;
    data['hoverBackgroundColor'] = hoverBackgroundColor;
    return data;
  }
}

class LW {
  List<int>? data;
  List<String>? backgroundColor;
  List<String>? hoverBackgroundColor;

  LW({this.data, this.backgroundColor, this.hoverBackgroundColor});

  LW.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    backgroundColor = json['backgroundColor'].cast<String>();
    hoverBackgroundColor = json['hoverBackgroundColor'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['backgroundColor'] = backgroundColor;
    data['hoverBackgroundColor'] = hoverBackgroundColor;
    return data;
  }
}

class L1M {
  List<int>? data;
  List<String>? backgroundColor;
  List<String>? hoverBackgroundColor;

  L1M({this.data, this.backgroundColor, this.hoverBackgroundColor});

  L1M.fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    backgroundColor = json['backgroundColor'].cast<String>();
    hoverBackgroundColor = json['hoverBackgroundColor'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['backgroundColor'] = backgroundColor;
    data['hoverBackgroundColor'] = hoverBackgroundColor;
    return data;
  }
}

class Options {
  int? cutoutPercentage;
  bool? spanGaps;
  Legend? legend;
  bool? maintainAspectRatio;

  Options({
    this.cutoutPercentage,
    this.spanGaps,
    this.legend,
    this.maintainAspectRatio,
  });

  Options.fromJson(Map<String, dynamic> json) {
    cutoutPercentage = json['cutoutPercentage'];
    spanGaps = json['spanGaps'];
    legend = json['legend'] != null ? Legend.fromJson(json['legend']) : null;
    maintainAspectRatio = json['maintainAspectRatio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cutoutPercentage'] = cutoutPercentage;
    data['spanGaps'] = spanGaps;
    if (legend != null) {
      data['legend'] = legend!.toJson();
    }
    data['maintainAspectRatio'] = maintainAspectRatio;
    return data;
  }
}

class Legend {
  bool? display;
  String? position;
  Labels? labels;

  Legend({this.display, this.position, this.labels});

  Legend.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    position = json['position'];
    labels = json['labels'] != null ? Labels.fromJson(json['labels']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    data['position'] = position;
    if (labels != null) {
      data['labels'] = labels!.toJson();
    }
    return data;
  }
}

class Labels {
  int? padding;
  bool? usePointStyle;

  Labels({this.padding, this.usePointStyle});

  Labels.fromJson(Map<String, dynamic> json) {
    padding = json['padding'];
    usePointStyle = json['usePointStyle'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['padding'] = padding;
    data['usePointStyle'] = usePointStyle;
    return data;
  }
}

class Ranges {
  String? lW;
  String? l2W;
  String? l1M;

  Ranges({this.lW, this.l2W, this.l1M});

  Ranges.fromJson(Map<String, dynamic> json) {
    lW = json['LW'];
    l2W = json['L2W'];
    l1M = json['L1M'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LW'] = lW;
    data['L2W'] = l2W;
    data['L1M'] = l1M;
    return data;
  }

  static const Map<String, String> labels = {
    "LW": "Last Week",
    "L2W": "Last 2 Weeks",
    "L1M": "Last 30 Days",
  };

  String? operator [](String key) => labels[key];
}

class Footer {
  String? title;
  Ranges? count;

  Footer({this.title, this.count});

  Footer.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'] != null ? Ranges.fromJson(json['count']) : null;
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
