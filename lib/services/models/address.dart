import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geo.dart';

part 'address.g.dart';

@JsonSerializable()
class Address extends Equatable {
	final String? street;
	final String? suite;
	final String? city;
	final String? zipcode;
	final Geo? geo;

	const Address({
		this.street, 
		this.suite, 
		this.city, 
		this.zipcode, 
		this.geo, 
	});

	factory Address.fromJson(Map<String, dynamic> json) {
		return _$AddressFromJson(json);
	}

	Map<String, dynamic> toJson() => _$AddressToJson(this);

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [street, suite, city, zipcode, geo];
}
