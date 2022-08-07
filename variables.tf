# Aqui alojamos las definiciones de las variables una para Clave SSH y 
# otra para VPC

# 1- La primera variable SSH indicaremos donde esta el archivo con la clave
variable "ssh_key_path" {}

# 2- Segundo indicamos que usaremos la VPC que tengamos defina por defecto
variable "vpc_id" {}