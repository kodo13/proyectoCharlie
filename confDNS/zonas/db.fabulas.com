$TTL 38400	; 10 hours 40 minutes
@		IN SOA	ns.fabulas.com. some.email.address. (
				10000002   ; serial
				10800      ; refresh (3 hours)
				3600       ; retry (1 hour)
				604800     ; expire (1 week)
				38400      ; minimum (10 hours 40 minutes)
				)
@		IN NS	ns.fabulas.com.
ns		IN A 	10.0.1.254
oscuras	IN A	10.0.1.250
maravillosas	IN CNAME    oscuras
alias	IN TXT    mensaje

