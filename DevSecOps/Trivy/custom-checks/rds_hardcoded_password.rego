package user.terraform.rds_hardcoded_password

import rego.v1

deny contains res if {
	resource := input.resource.aws_db_instance[_]
	pw := resource.password
	pw != ""
	res := result.new("RDS instance has a hardcoded password in the code.", resource)
}
