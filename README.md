# TreePI

## Webapp
Create a simple web server, using Python/Flask. The webserver should do the following:

 - Responds to `/version` with a Semver number
 - Only accepts GET requests, on the URL `/tree`
 - Returns a JSON response: `{"myFavouriteTree": "elm"}`

## Infra
Write all the necessary Docker and Kubernetes configuration manifests in order to deploy the application into a Kubernetes cluster. 
*Warning*: `make setup` and `make run` will create files on your local filesystem. `make clean` will remove build artifacts from this directory only (I hope).

For local testing, use minikube. The makefile commands `mkstart`, `mkconfig`, `mkbuild`, and `mkapply` should come in handy. If you already have minikube running, just use `make` alone.

The treepi is going to make use of the default namespace out of sheer laziness, for the time being. 

The application should be reachable outside of the cluster using an ingress object listening on the hostname local.ecosia.org (ie, we should be able to reach the service with curl localhost:<PORT>/tree -H Host:local.ecosia.org, where <PORT> is the port of your cluster's ingress controller). 

If after running `make`, the ingress controller isn't available, try running `minikube addons enable ingress` or `make mkstart`.

Running `make` will, in one command, build application, bundle the docker image, and apply the Kubernetes manifests into the cluster.
