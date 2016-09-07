sub vcl_pipe {
     # Note that only the first request to the backend will have
     # X-Forwarded-For set.  If you use X-Forwarded-For and want to
     # have it set for all requests, make sure to have:
     # set bereq.http.connection = "close";
     # here.  It is not set by default as it might break some broken web
     # applications, like IIS with NTLM authentication.
 
    # Al habilitar estas dos opciones, se logra enviar la ip del 
	# visitante a IIS y aplicaciones SADE que comenzaron a utilizanr 
	# la variable req.http.X-Forwarded-For
	#if (req.url ~ "(?i)\.(pdf|asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
	#if (req.url ~ "(?i)\.(asc|dat|txt|doc|xls|ppt|tgz|csv|png|gif|jpeg|jpg|ico|swf|css|js)(\?.*)?$") {
		
	#}else{
	#	set bereq.http.connection = "close";	## es lento en SADE
	#	return (pipe);
	#}
	
 }