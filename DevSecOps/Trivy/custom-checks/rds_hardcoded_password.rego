# METADATA
# title: "RDS instance has hardcoded password"
# description: "The 'password' attribute must not contain a literal value in the code. Use AWS Secrets Manager or SSM Parameter Store instead."
# scope: package
# custom:
#   id: USER-0001
#   avd_id: USER-0001
#   provider: aws
#   service: rds
#   severity: CRITICAL
#   short_code: no-hardcoded-password
#   recommended_actions: "Replace the literal value with a reference to AWS Secrets Manager."
#   input:
#     selector:
#       - type: terraform
package user.terraform.rds_hardcoded_password

import rego.v1

deny contains res if {
	resource := input.resource.aws_db_instance[_]
	pw := resource.password
	pw != ""
	res := result.new("RDS instance has a hardcoded password in the code.", resource)
}
