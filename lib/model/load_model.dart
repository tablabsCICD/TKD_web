import 'package:tkd_app/model/truck_load_model.dart';

class LoadModel {
  LoadModel({
    required this.content,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    this.sort,
    required this.first,
    required this.numberOfElements,
    required this.size,
    required this.number,
  });
  late final List<TruckLoad> content;
  late final bool last;
  late final int totalPages;
  late final int totalElements;
  late final String? sort;
  late final bool first;
  late final int numberOfElements;
  late final int size;
  late final int number;

  LoadModel.fromJson(Map<String, dynamic> json){
    content = List.from(json['content']).map((e)=>TruckLoad.fromJson(e)).toList();
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    sort = json['sort'];
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content.map((e)=>e.toJson()).toList();
    _data['last'] = last;
    _data['totalPages'] = totalPages;
    _data['totalElements'] = totalElements;
    _data['sort'] = sort;
    _data['first'] = first;
    _data['numberOfElements'] = numberOfElements;
    _data['size'] = size;
    _data['number'] = number;
    return _data;
  }
}
