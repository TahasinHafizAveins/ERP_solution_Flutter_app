import 'package:erp_solution/models/attendance_summery_result_model.dart';

class CommonUtils {
  static String getValue(List<Cells> teamDetail, String id) {
    return teamDetail
            .firstWhere(
              (cell) => cell.id == id,
              orElse: () => Cells(value: "-"),
            )
            .value ??
        "-";
  }
}
