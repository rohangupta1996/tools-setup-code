terraform {
  backend "s3" {
    bucket = "rohan2025bucket"
    key= "vault-secrets/state"
    region = "us-east-1"
  }
}
provider "vault" {
  address = "http://vault-internal.ro-bot.store:8200"
  token = var.vault_token
}

variable "vault_token" {}

resource "vault_mount" "ssh" {
  path        = "infra"
  type        = "kv"
  options     = { version = "2" }
  description = "Infra Secrets"
}



resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"

  data_json = <<EOT
{
  "username":   "ec2-user",
  "password": "DevOps321"
}
EOT
}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "Roboshop Dev Secrets"
}

resource "vault_generic_secret" "roboshop-dev-cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
  "REDIS_HOST":   "redis-dev.ro-bot.store",
  "CATALOGUE_HOST": "catalogue-{{ env }}.ro-bot.store"
  "CATALOGUE_PORT": 8080
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
  "MONGO":   "true",
  "MONGO_URL": "mongodb://mongo-dev.ro-bot.store:27017/catalogue"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
  "catalogue_url":   "http://catalogue-dev.ro-bot.store:8080/",
  "user_url": "http://user-dev.ro-bot.store:8080/",
  "cart_url": "http://cart-dev.ro-bot.store:8080/",
  "shipping_url": "http://shipping-dev.ro-bot.store:8080/",
  "payment_url": "http://payment-dev.ro-bot.store:8080/",


}
EOT
}

resource "vault_generic_secret" "roboshop-dev-payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
"CART_HOST" : "cart-dev.ro-bot.store",
"CART_PORT" : 8080,
"USER_HOST" : "user-dev.ro-bot.store",
"USER_PORT" : 8080,
"AMQP_HOST" : "rabbitmq-dev.ro-bot.store",
"AMQP_USER" : "roboshop",
"AMQP_PASS" : "roboshop123"

}
EOT
}

resource "vault_generic_secret" "roboshop-dev-shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOT
{

"CART_ENDPOINT" : "cart-dev.ro-bot.store:8080",
"DB_HOST" : "mysql-dev.ro-bot.store"


}
EOT
}

resource "vault_generic_secret" "roboshop-dev-user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOT
{

"MONGO" : "true",
"REDIS_URL" : "redis://redis-dev.ro-bot.store:6379",
"MONGO_URL" : "mongodb://mongo-dev.ro-bot.store:27017/users"


}
EOT
}

