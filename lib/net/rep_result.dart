
class RepResult {
  var data;
  bool status;
  int code;
  String msg;

  RepResult(this.data, this.status, this.code, {this.msg=""});

  @override
  String toString() {
    return 'RepResult{data: $data, result: $status, code: $code, msg: $msg}';
  }
}
