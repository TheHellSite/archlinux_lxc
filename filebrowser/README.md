1. pacman -Syyu stunnel
2. openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout key.pem -out cert.pem

  ```
; **************************************************************************
; * Global options                                                         *
; **************************************************************************

; It is recommended to drop root privileges if stunnel is started by root
setuid = stunnel
setgid = stunnel

; **************************************************************************
; * Service definitions (remove all services for inetd mode)               *
; **************************************************************************

[filebrowser-https]
client = no
accept = 0.0.0.0:8443
connect = 127.0.0.1:8080
cert = /etc/stunnel/cert.pem
key = /etc/stunnel/key.pem
  ```
