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
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgbVRKRx4y5bK7KiEKheElWEI/z086f6b3yOEHSI5RGTBJcxXxQ2Vkv2g/zrCK2BnPOGEF8QlcjAsZtD6HygKKQK2JNuTRdj/JrlziN3d7K2rDtQLunnYKyS5JjPhmoTFDiDgE639ITSJiMMLPNkrX2YYU90hTxqaIGoSLJeSsRTALXK5vtflCU/Q7pbdBSgpxtb85u7E0DxZQOSnl2cBz7iPuTcdyqjys1heIUGcJqig618Sd5N309EnZEObPovVPIBmeNqvHquTGTmEaWXsrO8uRodLrHAXKjpyHN2c1I/Hh0MGZqrA28FhGwQPwZvIhq2h0JBUAtxqplR8osAJFQ== rsa-key-20240321"
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
