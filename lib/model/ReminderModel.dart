class ReminderModel {
     String id;
     String drinkTime;
     String alarmId;
     String alarmType;
     String alarmInterval;

     int isOff;
     int sunday;
     int monday;
     int tuesday;
     int wednesday;
     int thursday;
     int friday;
     int saturday;

    ReminderModel({this.id, this.drinkTime,
        this.alarmId,
        this.alarmInterval,
        this.alarmType,
        this.isOff,
        this.sunday,
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
    });

    factory ReminderModel.fromJson(Map<String, dynamic> json) {
        return ReminderModel(
            id: json['Id'] != null ? json['Id'] : 0,
          drinkTime: json['drinkTime'] != null ? json['drinkTime'] : "",
          alarmId: json['alarmId'] != null ? json['alarmId'] : "",
          alarmType: json['alarmType'] != null ? json['alarmType'] : "",
          alarmInterval: json['alarmInterval'] != null ? json['alarmInterval'] : "",
          isOff: json['isOff'] != null ? json['isOff'] : 0,
          sunday: json['sunday'] != null ? json['sunday'] : 0,
          monday: json['monday'] != null ? json['monday'] : 0,
          tuesday: json['tuesday'] != null ? json['tuesday'] : 0,
          wednesday: json['wednesday'] != null ? json['wednesday'] : 0,
          thursday: json['thursday'] != null ? json['thursday'] : 0,
          friday: json['friday'] != null ? json['friday'] : 0,
          saturday: json['saturday'] != null ? json['saturday'] : 0,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Id'] = this.id;
        data['drinkTime'] = this.drinkTime;
        data['alarmId'] = this.alarmId;
        data['alarmType'] = this.alarmType;
        data['alarmInterval'] = this.alarmInterval;
        data['isOff'] = this.isOff;
        data['sunday'] = this.sunday;
        data['sunday'] = this.monday;
        data['monday'] = this.tuesday;
        data['wednesday'] = this.wednesday;
        data['thursday'] = this.thursday;
        data['friday'] = this.friday;
        data['saturday'] = this.saturday;
        return data;
    }
}