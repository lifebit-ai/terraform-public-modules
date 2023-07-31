Content-Type: multipart/mixed; boundary="==AWS=="
MIME-Version: 1.0

--==AWS==
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0

config system global
set hostname ${client}-HA-Active
set admin-sport ${adminsport}
set admintimeout 15
set pre-login-banner enable
set timezone 25
end
config system dns
set primary 8.8.8.8
end
config system interface
edit port1
set alias public
set mode static
set ip ${port1_ip} ${port1_mask}
set allowaccess ping https http
set mtu-override enable
set mtu 9001
next
edit port2
set alias private
set mode static
set ip ${port2_ip} ${port2_mask}
set allowaccess ping https
set mtu-override enable
set mtu 9001
next
edit port3
set alias hasync
set mode static
set ip ${port3_ip} ${port3_mask}
set allowaccess ping
set mtu-override enable
set mtu 9001
next
edit port4
set alias hamgmt
set mode static
set ip ${port4_ip} ${port4_mask}
set allowaccess ping https ssh fgfm
set mtu-override enable
set mtu 9001
next
end
config sys ha
set group-name AWS-HA
set priority 255
set mode a-p
set hbdev port3 100
set session-pickup enable
set ha-mgmt-status enable
config  ha-mgmt-interfaces
edit 1
set interface port4
set gateway ${mgmt_gateway_ip}
next
end
set override enable
set priority 255
set unicast-hb enable
set unicast-hb-peerip ${passive_peerip}
end
config router static
edit 1
set device port1
set gateway ${defaultgwy}
next
edit 2
set dst ${vpc_ip} ${vpc_mask}
set device port2
set gateway ${privategwy}
next
end
config system sdn
edit aws-ha
set type aws
set use-metadata-iam enable
next
end
config system vdom-exception
edit 1
set object system.interface
next
edit 2
set object router.static
next
edit 3
set object firewall.vip
next
end

%{ if type == "byol" }
--==AWS==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

${file(license_file)}

%{ endif }
--==AWS==--
