class Menus {
  List<MenuResult>? result;
  int? id;
  String? exception;
  int? status;
  bool? isCanceled;
  bool? isCompleted;
  bool? isCompletedSuccessfully;
  int? creationOptions;
  String? asyncState;
  bool? isFaulted;

  Menus({
    this.result,
    this.id,
    this.exception,
    this.status,
    this.isCanceled,
    this.isCompleted,
    this.isCompletedSuccessfully,
    this.creationOptions,
    this.asyncState,
    this.isFaulted,
  });

  Menus.fromJson(Map<String, dynamic> json) {
    if (json['Result'] != null) {
      result = <MenuResult>[];
      json['Result'].forEach((v) {
        result!.add(new MenuResult.fromJson(v));
      });
    }
    id = json['Id'];
    exception = json['Exception'];
    status = json['Status'];
    isCanceled = json['IsCanceled'];
    isCompleted = json['IsCompleted'];
    isCompletedSuccessfully = json['IsCompletedSuccessfully'];
    creationOptions = json['CreationOptions'];
    asyncState = json['AsyncState'];
    isFaulted = json['IsFaulted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    data['Id'] = id;
    data['Exception'] = exception;
    data['Status'] = status;
    data['IsCanceled'] = isCanceled;
    data['IsCompleted'] = isCompleted;
    data['IsCompletedSuccessfully'] = isCompletedSuccessfully;
    data['CreationOptions'] = creationOptions;
    data['AsyncState'] = asyncState;
    data['IsFaulted'] = isFaulted;
    return data;
  }
}

class MenuResult {
  int? menuID;
  int? parentID;
  int? applicationID;
  String? iD;
  String? title;
  String? translate;
  String? type;
  String? icon;
  String? url;
  String? badge;
  String? target;
  bool? exact;
  String? auth;
  Null? parameters;
  bool? isVisible;
  double? sequenceNo;
  bool? canCreate;
  bool? canRead;
  bool? canUpdate;
  bool? canDelete;
  bool? canReport;
  int? userID;

  /// this extra field for local nested menu structure
  List<MenuResult>? children;

  MenuResult({
    this.menuID,
    this.parentID,
    this.applicationID,
    this.iD,
    this.title,
    this.translate,
    this.type,
    this.icon,
    this.url,
    this.badge,
    this.target,
    this.exact,
    this.auth,
    this.parameters,
    this.isVisible,
    this.sequenceNo,
    this.canCreate,
    this.canRead,
    this.canUpdate,
    this.canDelete,
    this.canReport,
    this.userID,
    this.children,
  });

  MenuResult.fromJson(Map<String, dynamic> json) {
    menuID = json['MenuID'];
    parentID = json['ParentID'];
    applicationID = json['ApplicationID'];
    iD = json['ID'];
    title = json['Title'];
    translate = json['Translate'];
    type = json['Type'];
    icon = json['Icon'];
    url = json['Url'];
    badge = json['Badge'];
    target = json['Target'];
    exact = json['Exact'];
    auth = json['Auth'];
    parameters = json['Parameters'];
    isVisible = json['IsVisible'];
    sequenceNo = json['SequenceNo'];
    canCreate = json['CanCreate'];
    canRead = json['CanRead'];
    canUpdate = json['CanUpdate'];
    canDelete = json['CanDelete'];
    canReport = json['CanReport'];
    userID = json['UserID'];
    children = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MenuID'] = menuID;
    data['ParentID'] = parentID;
    data['ApplicationID'] = applicationID;
    data['ID'] = iD;
    data['Title'] = title;
    data['Translate'] = translate;
    data['Type'] = type;
    data['Icon'] = icon;
    data['Url'] = url;
    data['Badge'] = badge;
    data['Target'] = target;
    data['Exact'] = exact;
    data['Auth'] = auth;
    data['Parameters'] = parameters;
    data['IsVisible'] = isVisible;
    data['SequenceNo'] = sequenceNo;
    data['CanCreate'] = canCreate;
    data['CanRead'] = canRead;
    data['CanUpdate'] = canUpdate;
    data['CanDelete'] = canDelete;
    data['CanReport'] = canReport;
    data['UserID'] = userID;
    if (children != null) {
      data['Children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
