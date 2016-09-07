sub limpia_url{
	## http://apache2-q3:8080/browse/SWDEV-1097
	set req.url = regsuball(req.url, "&AMP;", "&");
	set req.url = regsuball(req.url, "&amp;", "&");
}