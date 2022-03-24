class AlarmModel {
    String alarmId;
    String alarmInterval;
    String alarmType;
    String alarmTime;
    int friday;
    int id;
    int isOff;
    int monday;
    int saturday;
    int sunday;
    int thursday;
    int tuesday;
    int wednesday;

    String alarmSundayId;
    String alarmMondayId;
    String alarmTuesdayId;
    String alarmWednesdayId;
    String alarmThursdayId;
    String alarmFridayId;
    String alarmSaturdayId;

    AlarmModel({
        this.alarmId, this.alarmInterval, this.alarmType, this.alarmTime, this.friday, this.id, this.isOff,
        this.monday, this.saturday, this.sunday, this.thursday, this.tuesday, this.wednesday,
        this.alarmSundayId, this.alarmMondayId, this.alarmTuesdayId, this.alarmWednesdayId, this.alarmThursdayId, this.alarmFridayId, this.alarmSaturdayId,
    });

    factory AlarmModel.fromJson(Map<String, dynamic> json) {
        return AlarmModel(
            alarmId: json['AlarmId'] != null ? json['AlarmId'] : "",
            alarmInterval: json['AlarmInterval'] != null ? json['AlarmInterval'] : "",
            alarmType: json['AlarmType'] != null ? json['AlarmType'] : "",
            alarmTime: json['AlarmTime'] != null ? json['AlarmTime'] : "",

            id: json['id'] != null ? json['id'] : 0,

            isOff: json['IsOff'] != null ? json['IsOff'] : 0,

            friday: json['Friday'] != null ? json['Friday'] : 0,
            monday: json['Monday'] != null ? json['Monday'] : 0,
            saturday: json['Saturday'] != null ? json['Saturday'] : 0,
            sunday: json['Sunday'] != null ? json['Sunday'] : 0,
            thursday: json['Thursday'] != null ? json['Thursday'] : 0,
            tuesday: json['Tuesday'] != null ? json['Tuesday'] : 0,
            wednesday: json['Wednesday'] != null ? json['Wednesday'] : 0,

            alarmSundayId: json['SundayAlarmId'] != null ? json['SundayAlarmId'] : "",
            alarmMondayId: json['MondayAlarmId'] != null ? json['MondayAlarmId'] : "",
            alarmTuesdayId: json['TuesdayAlarmId'] != null ? json['TuesdayAlarmId'] : "",
            alarmWednesdayId: json['WednesdayAlarmId'] != null ? json['WednesdayAlarmId'] : "",
            alarmThursdayId: json['ThursdayAlarmId'] != null ? json['ThursdayAlarmId'] : "",
            alarmFridayId: json['FridayAlarmId'] != null ? json['FridayAlarmId'] : "",
            alarmSaturdayId: json['SaturdayAlarmId'] != null ? json['SaturdayAlarmId'] : "",
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['alarmId'] = this.alarmId;
        data['alarmInterval'] = this.alarmInterval;
        data['alarmType'] = this.alarmType;
        data['AlarmTime'] = this.alarmTime;

        data['id'] = this.id;

        data['IsOff'] = this.isOff;

        data['Friday'] = this.friday;
        data['Monday'] = this.monday;
        data['Saturday'] = this.saturday;
        data['Sunday'] = this.sunday;
        data['Thursday'] = this.thursday;
        data['Tuesday'] = this.tuesday;
        data['Wednesday'] = this.wednesday;

        data['SundayAlarmId'] = this.alarmSundayId;
        data['MondayAlarmId'] = this.alarmMondayId;
        data['TuesdayAlarmId'] = this.alarmTuesdayId;
        data['WednesdayAlarmId'] = this.alarmWednesdayId;
        data['ThursdayAlarmId'] = this.alarmThursdayId;
        data['FridayAlarmId'] = this.alarmFridayId;
        data['SaturdayAlarmId'] = this.alarmSaturdayId;

        return data;
    }
}