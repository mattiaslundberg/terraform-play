FROM ubuntu:bionic

RUN apt-get update && apt-get install software-properties-common --yes
RUN add-apt-repository ppa:longsleep/golang-backports && \
  apt-get update && \
  apt-get install openssh-client curl unzip golang-go make git --yes

RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip /tmp/terraform.zip
RUN mv terraform /usr/bin
RUN git clone https://github.com/cloudamqp/terraform-provider-cloudamqp.git /tmp/cloudamqp
RUN cd /tmp/cloudamqp && go get -u && make install
