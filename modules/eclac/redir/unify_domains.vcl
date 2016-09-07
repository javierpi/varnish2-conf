sub centraliza_dominios{
	## 
	# CU-01: Reescribir dominio. www.cepal.cl, www.eclac.cl y www.eclac.org se redireccionan a www.cepal.org
	## CU-01:------------- Desde acá 
	#
	if (std.tolower(req.http.host) ~ "^(www\.)cepal\.cl" || 
        std.tolower(req.http.host) ~ "^(www\.)eclac\.cl"  ||
        std.tolower(req.http.host) ~ "^(www\.)eclac\.org" ) 
    {
        return(synth(750, "http://www.cepal.org" + req.url));
        
    } 
	
	if (std.tolower(req.http.host) ~ "^www.eclacpos.org") 
    {
		return(synth(751, "http://www.cepal.org/portofspain" + req.url));
    }

	## CU-02 - HASTA ACÁ
	
}