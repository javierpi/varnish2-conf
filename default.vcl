# Default backend definition.  Set this to point to your content
# server.
#
# Versión 2.11 para conferencias
##

# #################################
# solo para version 4.xx adelante
vcl 4.0;
# #################################

# ===================
# Las importaciones
import std;
import directors;
# ===================

# ===================
# Los includes
# ===================

	# De back_end
	# ------------
	# Servidores de back_end, directors y probe
	# Drupal
	include "config/back/drupal_7/devel/back_config.vcl";
	#include "config/back/drupal_7/qa/back_config.vcl";
	#include "config/back/drupal_7/pro/back_config.vcl";
	#include "config/back/drupal_7_conf/qa/back_config.vcl";
	# ------------
	# SADE
	#include "config/back/sade/devel/back_config.vcl";
	#include "config/back/sade/qa/back_config.vcl";
	include "config/back/sade/qa/back_config.vcl";

# Las listas (acl)
# ------------
# IPs permitidas de hacer purge
include "config/acl/purge.vcl";
# IPs permitidas de acceso a administración pasando por acá
include "config/acl/internos.vcl";

# Los módulos
# ------------
# de la CEPAL
# Centralizacion de dominios
include "modules/eclac/redir/unify_domains.vcl";
# Url no accesibles desde internet
include "modules/eclac/redir/deny_admin.vcl";
# Prepara solicitudes a Drupal
include "modules/eclac/redir/prepare_to_drupal.vcl";
# Limpia URLS
include "modules/eclac/url/clean_url.vcl";
# Detalle de errores 403 -> 503
include "modules/eclac/error/error_generico.vcl";

# Generales
# ---------

# Revisar como se utiliza, probarlo y habilitarlo
# Limpieza de cookies
# include "modules/cookies/clean_cookies.vcl";

# Revisar como se utiliza, probarlo y habilitarlo
## Agents
#include "modules/agent/user_agent.vcl";

# Revisar como se utiliza, probarlo y habilitarlo
# Log
#include "modules/log/log_basic.vcl";

# Revisar como se utiliza, probarlo y habilitarlo
# Compression
# include "modules/compression/handle_compression.vcl";

# Drupal_forbidden
include "modules/forbidden/drupal_7_forbidden.vcl";
 
# Estructura
# -----------
# vcl_deliver
include "structure/vcl_deliver.vcl";
include "structure/vcl_fetch.vcl";
include "structure/vcl_hit.vcl";
include "structure/vcl_miss.vcl";
include "structure/vcl_pipe.vcl";
include "structure/vcl_error.vcl";

# Respond to incoming requests.
sub vcl_init {
	include "config/back/drupal_director.vcl";
	include "config/back/sade_director.vcl";
}

sub vcl_recv {
	
	# CU-01 y 02: Redirigir a SADE dominios existentes:
	##
	call centraliza_dominios;
	call limpia_url;

	#if (req.url ~ "PURGE" || req.request == "PURGE") {
	if (req.url ~ "PURGE" ) {
     	if (client.ip ~ purge) {
				# =============================================
				# Se quita PURGE de la URL
				set req.url = regsub(req.url, "\/PURGE", "");
				# =============================================
				return(purge);
			} else {
       	return(synth(404, "Not allowed"));
     	}
 	}
	
	
  if (req.http.host == "www.cepal.org") {
		set req.backend_hint = sade_director.backend();
		# Force client.ip forwarding
		set req.http.X-Forwarded-For = client.ip;
		
		## retorno con Pipe: No hace caché, cortocircuitea entre cliente y servidor
		return(pipe);
	} else {
		set req.backend_hint = drupal_director.backend();
		call prepara_drupal;
	}

	## Utiliza caché de varnish para entregar esta página
	return(hash);
}
