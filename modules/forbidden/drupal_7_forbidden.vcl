sub forbiden_drupal7 {
	# Do not allow outside access to cron.php or install.php.
	# But it can if he is member of internal users.
	if (( 	req.url ~ "(?i)^/(install|status|update|cron|supercron)\.php(\?.*)?$"
			|| req.url ~ "(?i)^/(supercron\/run-autocron-.*).*$"
			|| req.url ~ "(?i)^/(admin|node\/add|devel.*).*$"
			|| req.url ~ "(?i)^/?(.*)(\/changelog|\/readme)\.txt/?(\?.*)?$"
			|| req.url ~ "^/sites/default/settings.php"
			|| req.url ~ "^/user$" 
			|| req.url ~ "^/es\/user$" 
			|| req.url ~ "^/en\/user$" 
			|| req.url ~ "^/node\/add$" 
			|| req.url ~ "^/es\/node\/add$" 
			|| req.url ~ "^/en\/node\/add$" 
			|| req.url ~ "^/info/.*$" 
			|| req.url ~ "^/flag/.*$" 
		)
		&& !client.ip ~ internal) {
			
			return(synth(752, ""));
	}
}
