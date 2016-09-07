## servidor webpre.cepal.org ---> QA
	
backend drupal1 {
	.host = "10.0.25.42"; 
	.port = "80";
	.probe = drupalprobe;
	.connect_timeout = 600s;
    .first_byte_timeout = 600s;
    .between_bytes_timeout = 600s;
	## Número de conecciones simultáneas al back_end
    .max_connections = 250;
}

#backend drupal2 {
#   .host = "10.0.1.2";
#   .port = 80;
#   .probe = drupalprobe;
#   .connect_timeout = 600s;
#   .first_byte_timeout = 600s;
#   .between_bytes_timeout = 600s;
#   .max_connections = 300;
# }
 
 
director drupal_director round-robin {
         .backend = drupal1;     
#      {    .backend = drupal2;     }
}

probe drupalprobe{
		# url: What URL should varnish request.
		# interval: How often should we poll
		# timeout: What is the timeout of the probe
		# window: Varnish will maintain a sliding window of the results. Here the window has five checks.
		# threshold: How many of the .window last polls must be good for the backend to be declared healthy.
		# initial: How many of the of the probes a good when Varnish starts - defaults to the same amount as the threshold.
         .url = "/";
         .interval = 5s;
         .timeout = 1 s;
         .window = 5;
         .threshold = 3;
}