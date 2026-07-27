resource "aws_instance" "example" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "c7i-flex.large"
  key_name = "old_key"
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "HelloWorld"
  }
}
output "ip" {
  value = aws_instance.example.public_ip
}
# 1. Look up your existing console-created EC2 instance by its Instance ID
# data "aws_instance" "existing_vm" {
#   instance_id = "i-010991df2367d183d" # Replace with your actual Instance ID
# }

# # 2. Tell AWS to change the state of that specific instance from Stopped to Running
# resource "aws_ec2_instance_state" "start_vm" {
#   instance_id = data.aws_instance.existing_vm.id
#   state       = "running"
# }
resource "null_resource" "run_commands" {
  # This block will execute ONLY after the instance changes its state to "running"
  depends_on = [aws_instance.example]

  # Establishes the SSH connection profile using details from the data source
  connection {
    type        = "ssh"
    user        = "ubuntu"                            # Change to 'ec2-user' if it's Amazon Linux
    private_key = file("rsa") # Path to your private key file
    host        = aws_instance.example.public_ip
  }

#   # The exact commands you want to run inside the instance
  provisioner "remote-exec" {
    inline = [
      "curl --silent --location 'https://github.com(uname -s)_amd64.tar.gz' | tar xz -C /tmp && sudo mv /tmp/eksctl /usr/local/bin",
      "sudo apt update && sudo snap install kubectl --classic",
      "sudo snap install aws-cli --classic"

    ]
  }
}
