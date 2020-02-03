Intro video: https://www.youtube.com/watch?v=HmxkYNv1ksg

Varför IaC:
 * Traceability (vi vet vem som gjort vad, när och varför)
 * Repeatability (vi kan göra om från början om det behövs)
 * Simplicity (enkelt att göra förändringar)

`play.tf` go through aws bootstrapping

Setup aws bootstrapping (`terraform plan` `terraform apply`)

Docs: https://www.terraform.io/docs/providers/aws/r/instance.html
Create aws instance (write description, `terraform plan` `terraform apply`)

Ssh to instance 

Go through ansible bootstrapping

Use ansible to install nginx
`ansible-playbook install.yaml`
