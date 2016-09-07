## SADE
## USANDO ESTE
## SADE Producción Front directo con IP Externa
backend sade1 {
   .host = "200.9.3.94";
   .port = "80";
   
   ## Número de conecciones simultáneas al back_end
   
   #.max_connections = 300;
   
   .connect_timeout = 5s;
   .first_byte_timeout = 120s;
   .between_bytes_timeout = 120s;
   
   #.probe = sadeprobe;
 }
 #backend sade2 {
 #  .host = "10.0.1.3";
 #  .port = "80";
 #  #.probe = sadeprobe;
 #  .connect_timeout = 600s;
 #  .first_byte_timeout = 600s;
 #  .between_bytes_timeout = 600s;
 #  .max_connections = 300;
 #}
 


director sade_director round-robin {
        {
                .backend = sade1;
        }
        {
                .backend = sade1;
        }
}

#probe sadeprobe{
#         .url = "/";
#         .interval = 5s;
#         .timeout = 1 s;
#         .window = 5;
#         .threshold = 3;
#}