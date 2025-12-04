enum FieldStyle { underline, box }

enum DataType {number, string}

enum RoleType { stationUser, shiftEngineer, mi, amo, cv, ci, noRole, driver, admin, lcvManager, cngStation } // CRIC

enum OrderStatus { pending, confirm, complete, cancel }

enum DeviceType { phone, tablet }

enum Client { iglcng }

enum MeasurementType {pre, post, sheet, non}

enum AssignmentStatus {
  pending,
  confirm,
  startRoute,
  complete,
  cancel
}

enum PageRoute { addAcknowledge, complaintDetail }

enum PopRouteName { completeTask, startRoute, notification }

enum MenuUrlMethodType {
   get,
   post
}
