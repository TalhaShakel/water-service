class SoundModel {
    int id;
    String soundName;
    String soundPath;
    bool isSelected;

    SoundModel({this.id, this.soundName, this.isSelected, this.soundPath});

    factory SoundModel.fromJson(Map<String, dynamic> json) {
        return SoundModel(
            id: json['Id'] != null ? json['Id'] : 0,
            soundName: json['SoundName'] != null ? json['SoundName'] : "",
            soundPath: json['SoundPath'] != null ? json['SoundPath'] : "",
            isSelected: json['IsSelected'] != null ? json['IsSelected'] : false,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Id'] = this.id;
        data['SoundName'] = this.soundName;
        data['SoundPath'] = this.soundPath;
        data['IsSelected'] = this.isSelected;
        return data;
    }
}