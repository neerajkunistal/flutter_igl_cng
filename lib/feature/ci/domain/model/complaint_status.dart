class ComplaintStatus {
  dynamic id;
  String? status;

  ComplaintStatus({this.status, this.id});

  static getComplaintData() {
    List<ComplaintStatus> list = [];
    list.add(ComplaintStatus(id: "1", status: "Approve"));
    list.add(ComplaintStatus(id: "2", status: "Reject"));
    list.add(ComplaintStatus(id: "4", status: "Send To Review"));
    return list;
  }
}
