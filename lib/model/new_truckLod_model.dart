class NewTruckLoadModel {
  List<NewTruckLoad>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  Null? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  NewTruckLoadModel(
      {this.content,
        this.last,
        this.totalElements,
        this.totalPages,
        this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  NewTruckLoadModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <NewTruckLoad>[];
      json['content'].forEach((v) {
        content!.add(new NewTruckLoad.fromJson(v));
      });
    }
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['size'] = this.size;
    data['number'] = this.number;
    return data;
  }
}

class NewTruckLoad {
  int? id;
  String? fullLoadChoice;
  String? transporterOrCustomerName;
  int? contactNumber;
  String? emailId;
  String? source;
  String? destination;
  String? typeOfCargo;
  String? otherDetails;
  String? vehicleSize;
  String? loadWeight;
  String? instructions;
  int? partLoad;
  int? date;
  String? os;
  String? loggedUserName;
  int? loggedTime;
  int? privatePost;
  int? dnd;
  String? typeOfPayment;
  String? image;
  String? tableName;
  String? mainTag;
  String? postingTime;
  String? type;
  String? topicName;
  int? rating;
  List<int>? listOfUserIds;
  List<String>? images;
  String? material;
  String? expireDate;
  String? transporterType;
  String? userList;

  NewTruckLoad(
      {this.id,
        this.fullLoadChoice,
        this.transporterOrCustomerName,
        this.contactNumber,
        this.emailId,
        this.source,
        this.destination,
        this.typeOfCargo,
        this.otherDetails,
        this.vehicleSize,
        this.loadWeight,
        this.instructions,
        this.partLoad,
        this.date,
        this.os,
        this.loggedUserName,
        this.loggedTime,
        this.privatePost,
        this.dnd,
        this.typeOfPayment,
        this.image,
        this.tableName,
        this.mainTag,
        this.postingTime,
        this.type,
        this.topicName,
        this.rating,
        this.listOfUserIds,
        this.images,
        this.material,
        this.expireDate,
        this.transporterType,
        this.userList});

  NewTruckLoad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullLoadChoice = json['fullLoadChoice'];
    transporterOrCustomerName = json['transporterOrCustomerName'];
    contactNumber = json['contactNumber'];
    emailId = json['emailId'];
    source = json['source'];
    destination = json['destination'];
    typeOfCargo = json['typeOfCargo'];
    otherDetails = json['otherDetails'];
    vehicleSize = json['vehicleSize'];
    loadWeight = json['loadWeight'];
    instructions = json['instructions'];
    partLoad = json['partLoad'];
    date = json['date'];
    os = json['os'];
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    privatePost = json['privatePost'];
    dnd = json['dnd'];
    typeOfPayment = json['typeOfPayment'];
    image = json['image'];
    tableName = json['tableName'];
    mainTag = json['mainTag'];
    postingTime = json['postingTime'];
    type = json['type'];
    topicName = json['topicName'];
    rating = json['rating'];
    if (json['listOfUserIds'] != null) {
      listOfUserIds = <int>[];
      json['listOfUserIds'].forEach((v) {
        listOfUserIds!.add(v);
      });
    }
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
    material = json['material']??'';
    expireDate = json['expireDate']??'';
    transporterType = json['transporterType']??'';
    userList = json['userList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullLoadChoice'] = this.fullLoadChoice;
    data['transporterOrCustomerName'] = this.transporterOrCustomerName;
    data['contactNumber'] = this.contactNumber;
    data['emailId'] = this.emailId;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['typeOfCargo'] = this.typeOfCargo;
    data['otherDetails'] = this.otherDetails;
    data['vehicleSize'] = this.vehicleSize;
    data['loadWeight'] = this.loadWeight;
    data['instructions'] = this.instructions;
    data['partLoad'] = this.partLoad;
    data['date'] = this.date;
    data['os'] = this.os;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['privatePost'] = this.privatePost;
    data['dnd'] = this.dnd;
    data['typeOfPayment'] = this.typeOfPayment;
    data['image'] = this.image;
    data['tableName'] = this.tableName;
    data['mainTag'] = this.mainTag;
    data['postingTime'] = this.postingTime;
    data['type'] = this.type;
    data['topicName'] = this.topicName;
    data['rating'] = this.rating;
    if (this.listOfUserIds != null) {
      data['listOfUserIds'] =
          this.listOfUserIds!.map((v) => v).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v).toList();
    }
    data['material'] = this.material;
    data['expireDate'] = this.expireDate;
    data['transporterType'] = this.transporterType;
    data['userList'] = this.userList;
    return data;
  }
}
