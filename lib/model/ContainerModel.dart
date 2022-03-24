class ContainerModel {
  String containerId;
  String containerValue;
  String containerValueOZ;
  bool isSelected = false;
  bool isOpen = false;
  bool isCustom = false;

  ContainerModel({
    this.containerId,
    this.containerValue,
    this.containerValueOZ,
    this.isSelected,
    this.isOpen,
    this.isCustom,
  });


  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      containerId: json['containerId'] != null ? json['containerId'] : "1",
      containerValue: json['containerValue'] != null ? json['containerValue'] : "",
      containerValueOZ: json['containerValueOZ'] != null ? json['containerValueOZ'] : "",
      isSelected: json['isSelected'] != null ? json['isSelected'] : false,
      isOpen: json['isOpen'] != null ? json['isOpen'] : false,
      isCustom: json['isCustom'] != null ? json['isCustom'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['containerId'] = this.containerId;
    data['containerValue'] = this.containerValue;
    data['containerValueOZ'] = this.containerValueOZ;
    data['isSelected'] = this.isSelected;
    data['isOpen'] = this.isOpen;
    data['isCustom'] = this.isCustom;
    return data;
  }
}