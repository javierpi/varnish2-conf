sub clean_cookies{
	# Varnish will, in the default configuration, not cache a object 
	# coming from the backend with a Set-Cookie header present. Also, if
	# the client sends a Cookie header, Varnish will bypass the cache 
	# and go directly to the backend.
	#// Remove has_js and Google Analytics __* cookies.
		set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(_[_a-z]+|has_js)=[^;]*", "");
	#// Remove a ";" prefix, if present.
		set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");
}

sub remove_drupal_cookies{
	# Always cache the following file types for all users. This list of extensions
	# appears twice, once here and again in vcl_fetch so make sure you edit both
	# and keep them equal.
	  if (req.url ~ "(?i)\.(pdf|asc|dat|txt|doc|docx|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
		unset req.http.Cookie;
		set req.http.x-mensaje =  req.http.x-mensaje +"(unset req.http.Cookie) ";
	}
	 
	#	 Remove all cookies that Drupal doesn't need to know about. We explicitly
	# list the ones that Drupal does need, the SESS and NO_CACHE. If, after
	# running this code we find that either of these two cookies remains, we
	#	will pass as the page cannot be cached.
	if (req.http.Cookie) {
		# 1. Append a semi-colon to the front of the cookie string.
		# 2. Remove all spaces that appear after semi-colons.
		# 3. Match the cookies we want to keep, adding the space we removed
		#    previously back. (\1) is first matching group in the regsuball.
		# 4. Remove all other cookies, identifying them by the fact that they have
		#    no space after the preceding semi-colon.
		# 5. Remove all spaces and semi-colons from the beginning and end of the
		#    cookie string.
		set req.http.Cookie = ";" + req.http.Cookie;
		set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");   
		set req.http.Cookie = regsuball(req.http.Cookie, ";(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)=", "; \1=");
		set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
		set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

		if (req.http.Cookie == "") {
			# If there are no remaining cookies, remove the cookie header. If there
			# aren't any cookie headers, Varnish's default behavior will be to cache
			# the page.
			unset req.http.Cookie;
			set req.http.x-mensaje =  req.http.x-mensaje +"(unset req.http.Cookie 2) ";
		} else {
			# If there is any cookies left (a session or NO_CACHE cookie), do not
			#	cache the page. Pass it on to Apache directly.
			return (pass);
		}
	}
}