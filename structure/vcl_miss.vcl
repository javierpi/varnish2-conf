sub vcl_miss {
	#if(req.request == "PURGE"){
	#	purge;
	#	error 204 "Not found in cache, no purging required.";
	#}
	
}

