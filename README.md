# ShellScripts

## download.sh
A collection of scripts to help you download the Linux and FreeBSD scripts from my github that help your setup a new desktop enverment, sudo or ssh.

```sh
./download.sh -S -f -s -B -j -d
```

-S download sshd.sh script.
-a download arch_setup.sh script.
-f download freebsd_setup.sh script.
-s download sudo_setup.sh script.
-B download bash_setup.sh script.
-j download django_setup.sh script. FreeBSD only.
-d download drupal_setup.sh script. FreeBSD only.
-p download freepbx_setup.sh script. FreeBSD only.
-P download fusionpbx_setup.sh script. FreeBSD only.
-h this Help Text.

## sshd.sh
Pass this script a user and it will set that user up with my public ssh key. Sets the ssh config to turn off root login and password authentication and enables and starts the ssh service.

```sh
./sshd.sh Richard
```

Will add my ssh public key to the user named 'Richard' enable sshd and turn off ssh password autentication and ssh root login.

## sudo_setup.sh
Pass this script a user and it will set that user up as sudo group and sets up the sudo group.

```sh
./sudo_setup.sh Richard
```

Will add user Richard to the sudo group and make sure the sudo group is enabled in sudoers file
