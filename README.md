# TreePI

## Webapp
Create a simple web server, using Python/Flask. The webserver should do the following:

 - Responds to `/version` with a Semver number
 - Only accepts GET requests, on the URL `/tree`
 - Returns a JSON response: `{"myFavouriteTree": "elm"}`

## Infra
Write all the necessary Docker and Kubernetes configuration manifests in order to deploy the application into a Kubernetes cluster. 
*Warning*: `make setup` and `make run` will create files on your local filesystem. `make clean` will remove build artifacts from this directory only (I hope).

For local testing, use minikube. The [Makefile](./Makefile) commands `mkstart`, `mkconfig`, `mkbuild`, and `mkapply` should come in handy. If you already have minikube running, just use `make` alone.

The treepi makes use of its own namespace to localize development and pain points. And to give us a nicely defined boundary for when we need to tear down everything.

The application is reachable outside of the minikube cluster using an ingress object listening on the hostname http://local.ecosia.org. The [Makefile](./Makefile) target `mktest` will Curl the external-ish IP of the minikube cluster:
  ```
 	curl -H"Host:local.ecosia.org" -kL http://192.168.99.100/tree
	curl -H"Host:local.ecosia.org" -kL http://192.168.99.100/version
  ```
  
We added a `/version` endpoint to the service to facilitate future upgrades. It would be great if we added it to the `/tree` path, though... like `/tree/version`.

## Troubleshooting
If after running `make`, the ingress controller isn't available, try running `minikube addons enable ingress` or `make mkstart`.

Running `make` will, in one command, build application, bundle the docker image, and apply the Kubernetes manifests into the cluster.
