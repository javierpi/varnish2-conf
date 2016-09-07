sub prepara_drupal{

	#  Use anonymous, cached pages if all backends are down.
	#if (!req.backend.healthy) {
	if (!std.healthy(req.backend_hint)) {
		#unset req.http.Cookie;
		#error 755 "";
		return(synth(755, ""));
	}

	#		En caso de necesitar poner el sitio en mantenimiento
	#		descomentar la linea siguiente (20141027 DdelMoral:
	#
	#		return(synth(500, "Site under maintenance"));

	# Allow the backend to serve up stale content if it is responding slowly.
	# set req.grace = 600s;

	# Client IP is forwarded (instead of the) además del proxy 
	if (req.restarts == 0) {
		if (req.http.x-forwarded-for) {
			set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
		} else {
			set req.http.X-Forwarded-For = client.ip;
		}
	}
	
	# stop accessing admin url
	call deny_admin_drupal;
	
	# Do not cache these paths.
	if (
		std.tolower(req.url) ~ "^.*/ajax/.*$" ||
		std.tolower(req.url) ~ "^.*/ahah/.*$" ||
		std.tolower(req.url) ~ "/search") 
	{ 
		return (pass);
	}

	
	#  No cachear post
	if (req.method == "POST"){
		return (pass);
	}

	 
	# Always cache the following file types for all users. This list of extensions
	# appears twice, once here and again in vcl_fetch so make sure you edit both
	# and keep them equal.
	if (std.tolower(req.url) ~ "(?i)\.(pdf|asc|dat|txt|doc|docx|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
		unset req.http.Cookie;
	}

	if (req.http.Cookie) {
		
		set req.http.Cookie = ";" + req.http.Cookie;
		set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");   
#		set req.http.Cookie = regsuball(req.http.Cookie, ";(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=", "; \1=");
		set req.http.Cookie = regsuball(req.http.Cookie, ";(S{1,2}ESS[a-z0-9]+|NO_CACHE|context_breakpoints)=", "; \1=");
		set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
		set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

		if (req.http.Cookie == "") {
			unset req.http.Cookie;
		} else {
			return (pass);
		}
	}


	call forbiden_drupal7;
		  
	# call remove_drupal_cookies;
	
}