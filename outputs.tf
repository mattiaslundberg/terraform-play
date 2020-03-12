# output "ip" {
#   value = module.sthlm-instance.ip
# }


// Instance output
output "instance_id" {
  value = "${cloudamqp_instance.rmq_bunny.id}"
}

output "instance_name" {
  value = "${cloudamqp_instance.rmq_bunny.name}"
}

output "instance_plan" {
  value = "${cloudamqp_instance.rmq_bunny.plan}"
}

output "instance_region" {
  value = "${cloudamqp_instance.rmq_bunny.region}"
}
