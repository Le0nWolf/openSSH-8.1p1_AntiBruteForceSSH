<b>OpenSSH Mod

This Mod/Hack of the Linux SSH Server allows you to see wrong passwords and ONLY wrong passwords in the log fiels.
When a password is typed in incorrectly then a litte timer is set to avoid brute force Attacks. When you dont want it remove the Sleep Command from: "auth-passwd.c" and from "auth-pam.c".
This SSH Mod has included the systemd patch. When you normally compile and install the official openssh-portable from: https://github.com/openssh/openssh-portable.git you will see that "systemctl restart ssh" or "systemctl start ssh" will not work becouse ssh will not tell the systemd deamon that the start was successfull and when you do "systemctl status ssh" then the active state will never be achieve and it will stuck in state: activating.
Here is an Example what the log looks like: 

Example: "/var/log/auth.log":
Apr 15 15:01:04 Pi sshd[993]: Invalid user tomcat from 192.168.178.34 port 53242
Apr 15 15:01:09 Pi sshd[993]: error: Could not get shadow information for NOUSER
Apr 15 15:01:09 Pi sshd[993]: SSHGuard: failed login attempt on User: 'tomcat' Password: '1q2w3e4r5t'
Apr 15 15:01:19 Pi sshd[993]: Failed password for invalid user tomcat from 192.168.178.34 port 53242 ssh2
Apr 15 15:01:28 Pi sshd[993]: Connection closed by invalid user tomcat 112.85.42.232 port 33850 [preauth]



The files i editet are:
- auth-passwd.c
- auth-pam.c
- configure.ac
- sshd.c

I have commented on all changes that have been made following this
Example from auth-passwd.c:

/*Added by Leon*/
        if (strcmp(encrypted_password, pw_password) != 0) {
                logit("SSHGuard: failed login attempt on User: '%.100s' Password: '%.100s'", authctxt->user, password);
                sleep(10);
        }
/*End*/


So you only need to open the files and search for the word: "Leon" to see the changes.



How to Compile:

#Install necessary Packets for building SSH
apt install build-essential zlib1g-dev libssl-dev libsystemd-dev pkg-config libpam0g-dev

autoreconf

#Configure
./configure --with-systemd --with-pam --prefix=/usr --sysconfdir=/etc/ssh

#Compile
make

#Install
make install

#Restart sshd
systemctl restart ssh



Or simply run my install.sh Skript



Sorry for Bad English I am German.
