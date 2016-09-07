#### ---- sub vcl_fetch {
sub vcl_backend_response{
	# back end ask to not store
	if(beresp.http.Surrogate-Control ~ "no-store") {
		set beresp.ttl = 0.2s;
		set beresp.uncacheable = true;
    return (deliver);
	}
	
#	# Drupal and SADE change of backend servers.
#	# First backend is drupal, when it has a 404, we try url in SADE
#	# beresp == Back-end response from the web server.
#	if (beresp.status == 404) {
#		## este debe ser el retorno de SADE
#		return(restart);
#	}
	
	
	if (std.tolower(bereq.url) ~ "(?i)\.(pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
		unset beresp.http.set-cookie;
    }
	
	
	# ************************************              ************************
	# ************************************ INICIO NUEVO ************************
	# ************************************              ************************
	# When servers start throwing out random errors, lets make the server a saint,
	# in saint mode. We will discard these 500 error, and varnish will not ask 
	# the server for 10 seconds. With the restart we sill try to use another backend server.
	# When there is no more backend server, varnish will serve the content from stale cache
	# if (beresp.status == 500) {
	# 	std.log("vcl_fetch(): Status 500 - restart with saintmode");
	# 	set beresp.saintmode = 10s;
	# 	return(restart);
	# }
  
	# # To make Varnish keep all objects for 30 minutes beyond their TTL use
	# set beresp.grace = 30m;
  
	# # HTTP 1.0 server might send "Pragma: nocache". Varnish ignore this, so lets make it !
	# if (beresp.http.Pragma ~ "nocache") {
	# 	### deprecado ! return(hit_for_pass);
	#	set beresp.uncacheable = true;
    #    set beresp.ttl = 120s;
    #    return (deliver);
	# } 
	
	# # if you cant modify the time to live of cms or site, lets make varnish define it
	# if (req.url ~ "^/legacy_broken_cms/") {
    #     set beresp.ttl = 5d;
    # }
	
	# if backend has not set cache control
	# if(!beresp.http.Cache-Control) {
	# 	set beresp.http.Cache-Control = "max-age=120";
	# }
	# ************************************************* FIN NUEVO ************************
	
	if (beresp.status == 500){
		#error 500 "";
		return (abandon);
		#return (synth(999, "Response"));
		# Legal returns are: "abandon" "deliver" "retry"
	}
	if (beresp.status == 403){
		#error 403 "";
		return (abandon);
	}
	set bereq.http.x-BackServerName = beresp.backend.name;
	
	
		
	# 12-Dic-2014: Se define TTL a objetos SADE para que queden  en caché
	if ( beresp.backend.name == "sade") {
		if (std.tolower(bereq.url) ~ "(?i)\.(asc|dat|txt|ppt|tgz|csv|png|gif|jpeg|jpg|ico|css|js)(\?.*)?$") {
			set beresp.ttl = 1209600 s;
			set beresp.http.Cache-Control = "public, max-age=1209600";
			
		}
	}
	
	#------------------------------------------------------------------------------------
	# para Drupal, Varnish ban type BAN LUCKER, es necesario agregar estas dos variables
	# es/admin/config/development/varnish
	# Indicado en https://www.drupal.org/node/1423560
	# set obj.http.x-host = req.host;
	# set obj.http.x-url = req.url;
	# Arreglado en comentarios # 8
	set beresp.http.x-url = bereq.url;
	set beresp.http.x-host = bereq.http.host;
	#------------------------------------------------------------------------------------
	
	# lastly, it sends the content 
	# return(deliver);
}

