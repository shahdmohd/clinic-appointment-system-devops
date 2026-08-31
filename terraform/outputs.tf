output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_port" {
  value = module.rds.rds_port
}

output "rds_db_name" {
  value = module.rds.rds_db_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "jenkins_public_ip" {
  value = module.jenkins.jenkins_public_ip
}

output "jenkins_public_dns" {
  value = module.jenkins.jenkins_public_dns
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "jenkins_initial_password_command" {
  value = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}