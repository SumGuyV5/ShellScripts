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
 
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAlR3m2xi7yTf65p9AwQNaBSQ4CtGQy5OvIBgFrqy8RkHTGE+iG/uIMJMkjR0t+kxfTcddCLwdEjKvjPFOD9r5w4OADFb/Mypz1xfMUmNUlmY5L/ks69676BA19L214jkI/qDNv0Nb7RSjm/WS3b10YESd5rI8vypeKQMa8lYPZos= rsa-key-20081215"
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

cat >> /etc/ssh/sshd_config  << EOF
PubkeyAcceptedAlgorithms=+ssh-rsa
EOF

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