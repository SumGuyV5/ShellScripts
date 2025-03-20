#!/bin/sh
if [ `whoami` != root ]; then 
  echo "Please run as root."
  exit 1
fi
if [ "$1" = "" ] || [ "$1" = "-h" ]; then 
  echo "Please run as root and pass the user name."
  exit 1
fi
 
if id "$1" >/dev/null 2>&1; then
  echo "user does exist."
else
  echo "user does not exist."
  exit 1
fi
 
USER_HOME=$(eval echo "~$1")
 
mkdir -p $USER_HOME/.ssh
 
#new ssh key
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAo+8sNZmI/kXxjihbY0Z+a8QrdG4fWbtLllfblMJMBVaRJAv7/vJ4GSmS6b8jij1/cS5r8HZz7i+Xy9E0lhySa8Io3aZNhDRxZRtJt+gocrEAFaC5WecM6ggXT8ERSX7Dl1aX2YmJU0HIph3lATPs3c6aKQuk18EmfFCLXJnW3iETEwc3gsq08BrcYlB+yMfsPf0UFgyBuZF9DBUlk8s2hpJ7zAAdrHUvd+YNgqVCW0wbA5hPysWvGOGNwcCGfnIxBiJGGB+IpnhHGKo0duaD8ctx6PYZ1tqHJacJ92P0XGP1J4/8u873B8P9iKS054wHmOFMHgN/rsSowppkCIc1phhin9p44JiexuXppGueyvrUWaPsWHHJbwVaPt257vHydieqXeCDkbHIER6hFfdFp69JmnrQvGPjcn+uJYWMLtSs35woKHM8vYrUVgulfS0jUMbKXm5sHA2jIPf+O7CWBDv4Qf0jDCOhIY7d3C6Id3WrIVpPWKzMuQrtjcNHfqLRH7VsNslC4tzzEwfePTmPxQYaO+72bUsb8Zii+eJB2t8/t+HWsQLxkn7L3gmNGP95Pg2cL6MHVCQjwX+QHZ75j8ZrMkiiM/ZTKbzz5poG+idBA9NCQuY/nSzdybIeipokTGPQyD+AuzvdsKuLaaeoIv+4th3SOArPtojIhwedziU= rsa-key-20250226"
cat > $USER_HOME/.ssh/authorized_keys << EOF
$PUBLIC_KEY
EOF
 
chmod 0700 $USER_HOME/.ssh
chmod 0600 $USER_HOME/.ssh/authorized_keys
 
chown -R $1:$1 $USER_HOME/.ssh
 
sed -i.bak 's/PermitRootLogin yes/PermitRootLogin no/gi' /etc/ssh/sshd_config
sed -i.bak '/# *PermitRootLogin no/s/^# *//gi' /etc/ssh/sshd_config
 
sed -i.bak 's/PasswordAuthentication yes/PasswordAuthentication no/gi' /etc/ssh/sshd_config
sed -i.bak '/# *PasswordAuthentication no/s/^# *//gi' /etc/ssh/sshd_config

#if [ -f /usr/bin/systemctl ]
if ([ -f /usr/bin/systemctl ] || [ -f /bin/systemctl ])
then
  #archlinux armbian
  echo "systemctl found."
  systemctl enable sshd
  systemctl start sshd
else
  #freebsd
  sed -i.bak '/sshd_enable/d' /etc/rc.conf

  echo 'sshd_enable="YES"' >> /etc/rc.conf
 
  service sshd start 
  service sshd restart
fi
