variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID de la AMI"
  type        = string
  default     = "ami-04681163a08179f28" 
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Nombre de la instancia EC2"
  type        = string
  default     = "sergio-ec2-0"
}

