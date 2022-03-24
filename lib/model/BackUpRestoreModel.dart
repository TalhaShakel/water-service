class BackUpRestoreModel {

    List<Map<String,dynamic>> lstContainer;
    List<Map<String,dynamic>> lstDrink;

    BackUpRestoreModel({
        this.lstContainer, this.lstDrink,
    });

    /*factory BackUpRestoreModel.fromJson(Map<String, dynamic> json) {
        return BackUpRestoreModel(
            lstContainer: json['lstContainer'] != null ? json['lstContainer'] : "",
            lstDrink: json['lstDrink'] != null ? json['lstDrink'] : "",

            lstContainer: json['lstContainer'] != null ? (json['lstContainer'] as List).map((i) => Map<String,dynamic>.fromJson(i)).toList() : [],
        );
    }
*/
    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['lstContainer'] = this.lstContainer;
        data['lstDrink'] = this.lstDrink;
        return data;
    }
}