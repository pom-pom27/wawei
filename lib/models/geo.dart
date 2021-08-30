import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo.g.dart';

@JsonSerializable()
class Geo extends Equatable {
	final String? lat;
	final String? lng;

	const Geo({this.lat, this.lng});

	factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);

	Map<String, dynamic> toJson() => _$GeoToJson(this);

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [lat, lng];
}
