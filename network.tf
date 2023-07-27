resource "aws_vpc" "new_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "new_vpc"
    }
}

resource "aws_subnet" "subnets" {
    count = 2
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    vpc_id = aws_vpc.new_vpc.id

    tags = {
        Name = var.tag_names[count.index]
    }
    depends_on = [
        aws_vpc.new_vpc
    ]
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.new_vpc.id
    tags = {
        Name = "igw"
    }
    depends_on = [
        aws_subnet.subnets
    ]
}

resource "aws_route_table" "routetable" {
    count = 2
    vpc_id = aws_vpc.new_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = var.route_table_names[count.index]
    }
    depends_on = [
        aws_internet_gateway.igw
    ]

}

resource "route_table_association" "association" {
    subnet_id = aws_subnet.subnets[0].id
    route_table_id = aws_route_table.routetable[0].id
    depends_on = [
        aws_route_table.routetable
    ]
}

resource "aws_security_group" "opensshandtomctporta" {
    vpc_id = aws_vpc.new_vpc.id
    ingress {
        from_port = local.ssh_port
        to_port = local.ssh_port
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    ingress {
        from_port = local.tomcat_port
        to_port = local.tomcat_port
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
    egress {
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
    }
    tags = {
        Name = "opensshandtomcatpoet"
    }
    depends_on = [
        aws_route_table_association.association
    ]
}
















