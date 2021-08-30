import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company extends Equatable {
	final String? name;
	final String? catchPhrase;
	final String? bs;

	const Company({this.name, this.catchPhrase, this.bs});

	factory Company.fromJson(Map<String, dynamic> json) {
		return _$CompanyFromJson(json);
	}

	Map<String, dynamic> toJson() => _$CompanyToJson(this);

	@override
	bool get stringify => true;

	@override
	List<Object?> get props => [name, catchPhrase, bs];
}
