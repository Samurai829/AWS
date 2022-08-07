# Asi se usa terraform para configurar AWS



# 2- Indicamos cual seria la imagen de sistema operativo que se usara
data "aws_ami" "ubuntu" {
    most_recent = true

# Aqui indicamos el nombre de la imagen la cual seria Ubuntu
    filter {
        name = "name"
        values = ["ubuntu/images/hvn-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }   

# Aqui declaramos otro filtro para la virtualizacion
    filter {
        name = "virtualization-type"
        values = ["hvn"]
    }    

# Aqui indicamos el dueño de la imagen que usaremos
    owners = ["099720109477"] # Canonical
}


# Aqui vamos a definir cada uno de los recursos que usaremos en AWS

# Esto es un recurso de aws el cual se requiere para asociar claves publicas
resource "aws_key_pair" "devops" {
  key_name   = "devops-key"
  public_key = file(var.ssh_key_path) # <-- Aqui indicamos la variable que contiene la clave SSH
}


# Este recurso es un grupo de seguridad el cual nos permitira acceder
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # <-- Con esto indicamos con que ip podemos entrar
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Este es otro recurso utilizado para dar de alta una maquina de aws
resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id  # <-- el ami es la imagen que se estaria usando
  instance_type = "t3.micro"
  key_name = aws_key_pair.devops.key_name
  vpc_security_group_ids = [ 

    aws_security_group.allow_ssh.id 
  ]
  tags = {
    Name = "HelloWorld"
  }
}
