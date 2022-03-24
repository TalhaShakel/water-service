class OnBoardingModel {
  String languageName;

  String name;

  bool gender;

  String height;
  bool heightUnit;
  String weight;
  bool weightUnit;

  bool active;
  bool pregnant;
  bool breastfeeding;

  int weatherCondition;

  String wakeUpTime;
  String bedTime;

  String waterUnit;

  OnBoardingModel(
      {
        this.languageName,
        this.name,
        this.gender,
        this.height,
        this.heightUnit,
        this.weight,
        this.weightUnit,
        this.active,
        this.pregnant,
        this.breastfeeding,
        //this.otherFactor,
        this.weatherCondition,
        this.wakeUpTime,
        this.bedTime,
        this.waterUnit,
      });

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
      languageName: json['languageName'] != null ? json['languageName'] : "",
      name: json['name'] != null ? json['name'] : "",
      gender: json['gender'] != null ? json['gender'] : true,
      height: json['height'] != null ? json['height'] : "5.0",
      heightUnit: json['heightUnit'] != null ? json['heightUnit'] : false, // default feet
      weight: json['weight'] != null ? json['weight'] : "80.0",
      weightUnit: json['weightUnit'] != null ? json['weightUnit'] : false, // default kg
      active: json['active'] != null ? json['active'] : false,
      pregnant: json['pregnant'] != null ? json['pregnant'] : false,
      breastfeeding: json['breastfeeding'] != null ? json['breastfeeding'] : false,
      //otherFactor: json['otherFactor'] != null ? json['otherFactor'] : "",
      weatherCondition: json['weatherCondition'] != null ? json['weatherCondition'] : 0,
      wakeUpTime: json['wakeUpTime'] != null ? json['wakeUpTime'] : "",
      bedTime: json['bedTime'] != null ? json['bedTime'] : "",
      waterUnit: json['waterUnit'] != null ? json['waterUnit'] : "ml",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['languageName'] = this.languageName;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['active'] = this.active;
    data['pregnant'] = this.pregnant;
    data['breastfeeding'] = this.breastfeeding;
    //data['otherFactor'] = this.otherFactor;
    data['weatherCondition'] = this.weatherCondition;
    data['wakeUpTime'] = this.wakeUpTime;
    data['bedTime'] = this.bedTime;
    data['waterUnit'] = this.waterUnit;
    return data;
  }
}
