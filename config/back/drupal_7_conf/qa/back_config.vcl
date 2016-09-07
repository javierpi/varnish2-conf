##  Drupal
## servidor webtesting.cepal.org

backend drupal1 {
	.host = "apache2-q4.cepal.org"; 
	.port = "80";
	#.probe = drupalprobe;
	# habilitado el 20-mayo-2015 en desarrollo
   .max_connections = 200;
   ###
   
   .connect_timeout = 10s;
   .first_byte_timeout = 120s;
   .between_bytes_timeout = 120s;
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
 


#probe drupalprobe{
		# url: What URL should varnish request.
		# interval: How often should we poll
		# timeout: What is the timeout of the probe
		# window: Varnish will maintain a sliding window of the results. Here the window has five checks.
		# threshold: How many of the .window last polls must be good for the backend to be declared healthy.
		# initial: How many of the of the probes a good when Varnish starts - defaults to the same amount as the threshold.
#         .url = "/";
#         .interval = 5s;
#         .timeout = 1 s;
#         .window = 5;
#         .threshold = 3;
#}