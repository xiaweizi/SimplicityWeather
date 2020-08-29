import 'package:flutter_dynamic_weather/model/district_model_entity.dart';

districtModelEntityFromJson(DistrictModelEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['info'] != null) {
		data.info = json['info']?.toString();
	}
	if (json['count'] != null) {
		data.count = json['count']?.toString();
	}
	if (json['districts'] != null) {
		data.districts = new List<DistrictModelDistrict>();
		(json['districts'] as List).forEach((v) {
			data.districts.add(new DistrictModelDistrict().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> districtModelEntityToJson(DistrictModelEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['info'] = entity.info;
	data['count'] = entity.count;
	if (entity.districts != null) {
		data['districts'] =  entity.districts.map((v) => v.toJson()).toList();
	}
	return data;
}

districtModelDistrictFromJson(DistrictModelDistrict data, Map<String, dynamic> json) {
	if (json['adcode'] != null) {
		data.adcode = json['adcode']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['center'] != null) {
		data.center = json['center']?.toString();
	}
	if (json['level'] != null) {
		data.level = json['level']?.toString();
	}
	if (json['districts'] != null) {
		data.districts = new List<DistrictModelDistrictsDistrict>();
		(json['districts'] as List).forEach((v) {
			data.districts.add(new DistrictModelDistrictsDistrict().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> districtModelDistrictToJson(DistrictModelDistrict entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['adcode'] = entity.adcode;
	data['name'] = entity.name;
	data['center'] = entity.center;
	data['level'] = entity.level;
	if (entity.districts != null) {
		data['districts'] =  entity.districts.map((v) => v.toJson()).toList();
	}
	return data;
}

districtModelDistrictsDistrictFromJson(DistrictModelDistrictsDistrict data, Map<String, dynamic> json) {
	if (json['adcode'] != null) {
		data.adcode = json['adcode']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['center'] != null) {
		data.center = json['center']?.toString();
	}
	if (json['level'] != null) {
		data.level = json['level']?.toString();
	}
	if (json['districts'] != null) {
		data.districts = new List<dynamic>();
		data.districts.addAll(json['districts']);
	}
	return data;
}

Map<String, dynamic> districtModelDistrictsDistrictToJson(DistrictModelDistrictsDistrict entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['adcode'] = entity.adcode;
	data['name'] = entity.name;
	data['center'] = entity.center;
	data['level'] = entity.level;
	if (entity.districts != null) {
		data['districts'] =  [];
	}
	return data;
}