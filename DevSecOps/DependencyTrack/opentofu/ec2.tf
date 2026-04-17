# Create a new host with instance type of c5.18xlarge with Auto Placement
# and Host Recovery enabled.
resource "aws_ec2_host" "dependency_track" {
  instance_type     = "t2.large"
  availability_zone = "us-west-2a"
  host_recovery     = "off"
  auto_placement    = "on"
}
