variable "vpc_cidr" {
    type = string
}

variable "tag_names" {
    type = list(string)
}

variable "route_table_names" {
    type = list(string)
}