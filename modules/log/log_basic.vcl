
# Here you can specify what gets logged when a rule triggers.
sub sec_log {
         std.log("security.vcl alert xid:" + req.xid + " " + req.proto
             + " [" + req.http.X-VSF-Module + "-" + req.http.X-VSF-RuleId + "]"
             + req.http.X-VSF-Client
             + " (" +  req.http.X-VSF-RuleName + ") ");
         // call vsf_syslog
}

/*
sub vsf_syslog {
	C{
		syslog(LOG_INFO, "<VSF> %f [%s/ruleid:%s]: %s - %s http://%s %s - %s", VRT_r_now(sp), VRT_GetHdr(sp, HDR_REQ, "\015X-VSF-RuleName:"), VRT_GetHdr(sp, HDR_REQ, "\015X-VSF-RuleID:"), VRT_GetHdr(sp, HDR_REQ, "\017X-VSF-ClientIP:"), VRT_GetHdr(sp, HDR_REQ, "\015X-VSF-Method:"), VRT_GetHdr(sp, HDR_REQ, "\012X-VSF-URL:"), VRT_GetHdr(sp, HDR_REQ, "\014X-VSF-Proto:"), VRT_GetHdr(sp, HDR_REQ, "\011X-VSF-UA:"));
	}C
}
*/
