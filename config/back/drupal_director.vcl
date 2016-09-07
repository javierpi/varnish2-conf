new drupal_director = directors.round_robin();
    drupal_director.add_backend(drupal1);
    
#director drupal_director round-robin {
#          .backend = drupal1;     
#}