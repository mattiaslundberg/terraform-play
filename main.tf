provider "aws" {
  profile    = "codelabs"
  region     = "eu-north-1"
}

resource "aws_key_pair" "mattias" {
  key_name   = "mattias-public-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQHde4y3bjidC7XpXOLwqe5TiXHFXgHYECe612cE32E9zn4JiBV3J7fKCLUxCVK3+jClJEQr263V75YQwD1giR3nhB9rkEAdXJra506hmSSxEn4Gm/KnzUc411RcCggcBNNbUGQ3FxM7M7cMkS4iFJb2erkVHFc1Gc4+nSBrSxCWbCTS6DQVm4hE3eFP7IGvwzbPPj6YtBIxpPzQvhkVgjZtY9IZbCCp+Z7ctcQkbb0ox6USJHJmIYDaGEBbqMAesfZHhnG0cGDDRRzl5Xk/yLA7wpb40Grt1tCucXsUdXdJpD2xxiBYPtyK1j7kkU4Me4rNAMBZA6MVBADjj85q2j mattias"
}

resource "aws_instance" "instance" {
  ami           = "ami-01d965b90792d9bf7"
  instance_type = "t3.micro"
  key_name = aws_key_pair.mattias.key_name

  tags = {
    Name = "Mattias"
    Maintainer = "Mattias"
  }
}
