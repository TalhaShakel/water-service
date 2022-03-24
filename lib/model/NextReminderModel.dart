class NextReminderModel {
    int millisecond;
    String time;

    NextReminderModel({this.millisecond, this.time});

    factory NextReminderModel.fromJson(Map<String, dynamic> json) {
        return NextReminderModel(
            millisecond: json['millisecond'],
            time: json['time'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['millisecond'] = this.millisecond;
        data['time'] = this.time;
        return data;
    }
}