output "web_instance_ip" {
    value = aws_instance.web_server.public_ip
}

output "web_instance_dns" {
    value = aws_instance.web_server.public_dns
}