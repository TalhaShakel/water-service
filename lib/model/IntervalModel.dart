class IntervalModel {
    int id;
    bool isSelected;
    String name;

    IntervalModel({this.id, this.isSelected, this.name});

    factory IntervalModel.fromJson(Map<String, dynamic> json) {
        return IntervalModel(
            id: json['id'], 
            isSelected: json['isSelected'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['isSelected'] = this.isSelected;
        data['name'] = this.name;
        return data;
    }
}