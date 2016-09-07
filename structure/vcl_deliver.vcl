sub vcl_deliver {
	if (client.ip ~ internal) {
		
		if (obj.hits > 0) {
				set resp.http.X-Cache-Varnish = "HIT:(" + obj.hits + ")";
				
		} else {
				set resp.http.X-Cache-Varnish = "MISS";
		}
	}else{
		unset resp.http.x-BackServerName;
		unset resp.http.X-Drupal-Cache;
		unset resp.http.X-Forwarded-For;
		unset resp.http.x-host;
		unset resp.http.X-IE-Device;
		unset resp.http.X-UA-Compatible;
		unset resp.http.x-url;

		unset resp.http.Via;
		unset resp.http.X-Whatever;
		unset resp.http.X-Powered-By;
		unset resp.http.X-Varnish;
		unset resp.http.Age;
		unset resp.http.Server;
		unset resp.http.x-mensaje;
		unset resp.http.Via;
		unset resp.http.X-Cache-Varnish;
		unset resp.http.x-mensaje;
		unset resp.http.x-req.url;
		unset resp.http.x-restarts;
		
		# para Drupal, Varnish ban type BAN LUCKER, es necesario agregar estas dos variables
		# es/admin/config/development/varnish
		unset resp.http.x-host; # Optional
		unset resp.http.x-url; # Optional
		
		
	}
	set resp.http.X-Forwarded-For = req.http.X-Forwarded-For;
	
}