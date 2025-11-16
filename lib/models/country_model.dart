class CountryModel {
  int? value;
  String? label;
  bool? isDisabled;
  var extraJsonProps;

  CountryModel({this.value, this.label, this.isDisabled, this.extraJsonProps});

  CountryModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
    isDisabled = json['isDisabled'];
    extraJsonProps = json['extraJsonProps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['label'] = label;
    data['isDisabled'] = isDisabled;
    data['extraJsonProps'] = extraJsonProps;
    return data;
  }
}
