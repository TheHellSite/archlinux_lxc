openssl req -x509 -newkey rsa:4096 -sha512 -days 36500 -nodes -subj "/" -keyout cert.pem -out cert.pem

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

  [filebrowser]
  client = no
  accept = 0.0.0.0:8443
  connect = 127.0.0.1:8080
  cert = /etc/stunnel/cert.pem

  ; ***************************************** Example TLS server mode services

  ;[filebrowser]
  ;accept = 8443
  ;connect = 8080
  ;cert = /etc/stunnel/cert.pem

  ; TLS front-end to a web server
  ;[https]
  ;accept  = 443
  ;connect = 80
  ;cert = /etc/stunnel/stunnel.pem
  ; "TIMEOUTclose = 0" is a workaround for a design flaw in Microsoft SChannel
  ; Microsoft implementations do not use TLS close-notify alert and thus they
  ; are vulnerable to truncation attacks
  ;TIMEOUTclose = 0

  ; vim:ft=dosini
  ```
