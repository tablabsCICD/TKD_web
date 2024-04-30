import 'package:tkd_app/model/transport_model.dart';

class TransportSearchModel {
  List<TransportSearchData>? content;
  bool? last;
  int? totalElements;
  int? totalPages;
  //Null? sort;
  bool? first;
  int? numberOfElements;
  int? size;
  int? number;

  TransportSearchModel(
      {this.content,
        this.last,
        this.totalElements,
        this.totalPages,
        //this.sort,
        this.first,
        this.numberOfElements,
        this.size,
        this.number});

  TransportSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <TransportSearchData>[];
      json['content'].forEach((v) {
        content!.add(new TransportSearchData.fromJson(v));
      });
    }
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
   // sort = json['sort'];
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
  //  data['sort'] = this.sort;
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['size'] = this.size;
    data['number'] = this.number;
    return data;
  }
}

class TransportSearchData {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? emailId;
  int? mobileNumber;
  String? companyName;
  String? companyAddress;
  String? city;
  String? state;
  String? country;
  int? landlineNumber;
  int? verified;
  String? companyLogo;
  String? aadharCard;
  double? ratings;
  String? profilePicture;
  String? loggedUserName;
  String? loggedTime;
  int? transporterOrAgent;
  int? isPaid;
  String? paidStartDate;
  String? validTill;
  String? website;
  List<ListOfPreferredRoutes>? listOfPreferredRoutes;
  String? title;
  String? mainTag;
  List<String>? images;
  String? type;

  TransportSearchData(
      {this.id,
        this.userName,
        this.firstName,
        this.lastName,
        this.emailId,
        this.mobileNumber,
        this.companyName,
        this.companyAddress,
        this.city,
        this.state,
        this.country,
        this.landlineNumber,
        this.verified,
        this.companyLogo,
        this.aadharCard,
        this.ratings,
        this.profilePicture,
        this.loggedUserName,
        this.loggedTime,
        this.transporterOrAgent,
        this.isPaid,
        this.paidStartDate,
        this.validTill,
        this.website,
        this.listOfPreferredRoutes,
        this.title,
        this.mainTag,
        this.images,
        this.type});

  TransportSearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    mobileNumber = json['mobileNumber'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    landlineNumber = json['landlineNumber'];
    verified = json['verified'];
    companyLogo = json['companyLogo']??'';
    aadharCard = json['aadharCard']??'';
    ratings = json['ratings']??0.0;
    profilePicture = json['profilePicture']??"";
    loggedUserName = json['loggedUserName'];
    loggedTime = json['loggedTime'];
    transporterOrAgent = json['transporterOrAgent'];
    isPaid = json['isPaid'];
    paidStartDate = json['paidStartDate'];
    validTill = json['validTill'];
    website = json['website'];
    if (json['listOfPreferredRoutes'] != null) {
      listOfPreferredRoutes = <ListOfPreferredRoutes>[];
      json['listOfPreferredRoutes'].forEach((v) {
        listOfPreferredRoutes!.add(new ListOfPreferredRoutes.fromJson(v));
      });
    }
    title = json['title'];
    mainTag = json['mainTag'];
    images = json['images'].cast<String>();
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v);
      });
    }
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['mobileNumber'] = this.mobileNumber;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['landlineNumber'] = this.landlineNumber;
    data['verified'] = this.verified;
    data['companyLogo'] = this.companyLogo;
    data['aadharCard'] = this.aadharCard;
    data['ratings'] = this.ratings;
    data['profilePicture'] = this.profilePicture;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    data['transporterOrAgent'] = this.transporterOrAgent;
    data['isPaid'] = this.isPaid;
    data['paidStartDate'] = this.paidStartDate;
    data['validTill'] = this.validTill;
    data['website'] = this.website;
    if (this.listOfPreferredRoutes != null) {
      data['listOfPreferredRoutes'] =
          this.listOfPreferredRoutes!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['mainTag'] = this.mainTag;
    data['images'] = this.images;
    data['type'] = this.type;
    return data;
  }
}







class ListOfPreferredRoutes {
  int? id;
  int? userId;
  String? routeSource;
  String? routeDestination;
  String? loggedUserName;
  String? loggedTime;

  ListOfPreferredRoutes(
      {this.id,
        this.userId,
        this.routeSource,
        this.routeDestination,
        this.loggedUserName,
        this.loggedTime});

  ListOfPreferredRoutes.fromJson(Map<String, dynamic> json) {
    id = json['id']?? 0 ;
    userId = json['userId']?? 0;
    routeSource = json['routeSource']?? '';
    routeDestination = json['routeDestination']?? '';
    loggedUserName = json['loggedUserName']?? '';
    loggedTime = json['loggedTime']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['routeSource'] = this.routeSource;
    data['routeDestination'] = this.routeDestination;
    data['loggedUserName'] = this.loggedUserName;
    data['loggedTime'] = this.loggedTime;
    return data;
  }
}
