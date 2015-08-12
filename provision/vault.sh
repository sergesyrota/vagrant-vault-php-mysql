#!/bin/bash
apt-get update
apt-get install zip -y
wget -q -O /tmp/vault.zip https://dl.bintray.com/mitchellh/vault/vault_0.2.0_linux_386.zip
unzip -d /tmp /tmp/vault.zip
mv /tmp/vault /usr/bin
cp /vagrant/provision/vault-upstart.conf /etc/init/vault.conf
service vault start
rm -f /tmp/vault.zip
export VAULT_ADDR=http://127.0.0.1:8200
vault init > /tmp/vault-init.log
eval vault unseal `cat /tmp/vault-init.log | grep "Key 1" | awk 'BEGIN { FS="[ ]" }; {print $3}'`
eval vault unseal `cat /tmp/vault-init.log | grep "Key 2" | awk 'BEGIN { FS="[ ]" }; {print $3}'`
eval vault unseal `cat /tmp/vault-init.log | grep "Key 3" | awk 'BEGIN { FS="[ ]" }; {print $3}'`
cat /tmp/vault-init.log | grep "Initial Root Token" | awk 'BEGIN { FS="[ ]" }; {print $4}' > /vagrant/vault-root-token
eval vault auth `cat /vagrant/vault-root-token`
vault mount mysql
vault write mysql/config/connection value="vault:vault@tcp(192.168.50.3:3306)/"
vault write mysql/config/lease lease=10s lease_max=1h
vault write mysql/roles/readonly sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON vault.* TO '{{name}}'@'%';"
vault write mysql/roles/vault sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT ALL PRIVILEGES ON vault.* TO '{{name}}'@'%';"
