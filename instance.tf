resource "aws_instance" "tomcat_instance" {
    count = "${terraform.workspace == "dev" ? 1 : 0}"
    ami = "ami-053b0d53c279acc90"
    associate_public_ip_address = true
    availability_zone = "us-east-1"
    key_name = "k8skey"
    instance_type ="t2.micro"
    subnet_id = "aws_subnet.subnets[0].id"
    vpc_security_group_ids = ["aws_security_group.opensshandtomctporta.id"]
    tags = {
        Name = "tomcat_instance"
    }
    depends_on = [
        aws_security_group.opensshandtomctporta
    ]
}

resource "null_resource" "script" {
    provisioner "remote_exec" {
        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file("~/.ssh/id_rsa")
            host = aws_instance.tomcat_instance.public_ip
        }
        inline = [
            "sudo apt update",
            "sudo apt install tomcat9 -y"
        ]
    }
}