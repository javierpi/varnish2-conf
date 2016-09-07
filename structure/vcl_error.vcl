####--- > deprecado en ver 4.0 sub vcl_error {
sub vcl_backend_error{
	##  Legal returns are: "deliver" "retry"

	# CU-01: Reescribir dominio. www.cepal.cl, www.eclac.cl y www.eclac.org se redireccionan a www.cepal.org
	## CU-01:------------- Desde acá 
	if (beresp.status == 301) {
		# 750
		#set resp.http.Location = resp.response;
        #HTTP 301 para indicar redirección permanente
        return(deliver);
    }

	## CU-01:------------- Hasta acá 
	
	## 
	# CU-02: Reescribir dominio. 
	# socinfo.cepal.org
	# www.ilpes.cl
	# www.ofilac.org
	# www.eclacpos.org
	# www.cepal.org.mx
	## CU-02:------------- Desde acá 
	if (beresp.status == 302) {
		# 751
		#set resp.http.Location = obj.response;
        #HTTP 302 para indicar redirección temporal - Así estaba en IIS
        #set obj.status = 302;
        return(deliver);
    }
	## CU-02:------------- Hasta acá 
	
	
	## restart > 1.
	## No se ha encontrado
	if (beresp.status == 404) {
		# 753
		# Se cambia para no indicar que existe y está prohibido
		# set obj.status = 404;
		# return (synth(404, "Response"));
		return(deliver);
	}
	
	## Acceso denegado. Han enviado URL que se ha programado no entregar.
	if (beresp.status == 404) {
		# 752
		# Se cambia para no indicar que existe y está prohibido
		# set obj.status = 404;
		#call error_404;
		#return (synth(404, "Response"));
        return(deliver);
	}
	
	## Si no encuentra el contenido, cambie de back_end
	if (beresp.status == 404 ) {
	#&& req.restarts < 2
		return(retry);
	} else if (beresp.status == 404 ) {
		#call error_404;
        return(deliver);
  	}
	
	if (beresp.status == 403 ) {
		#call error_403;
		#return (synth(403, "Response"));
        #return(deliver);
	} 
	if (beresp.status == 500 ) {
		return(deliver);	
		#return (synth(500, "Response"));
	}
	if (beresp.status == 503 ) {
		#call error_503;
		#return (synth(503, "Response"));
		return(deliver);
	}
	
	# Aún no terminado
	#if (obj.status == 755 ) {
	#	call error_graphicless_msg;
	#	return(deliver);
	#}
	
	
	
	
}