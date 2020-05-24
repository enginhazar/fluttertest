class Header {
  String key;
  String value;

  Header({this.key, this.value});

  Header.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
