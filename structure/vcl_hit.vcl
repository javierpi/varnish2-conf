sub vcl_hit { 
	#if (bereq.request == "PURGE") {
    #    # retired --> purge; 
    #    return(synth(204, "Purged"));
    #}
}