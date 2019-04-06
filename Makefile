# --vars
SHELL := /bin/bash
BREW_DEPS=git docker kubernetes-cli python3
BREW_CASK_DEPS=virtualbox minikube
PIP_DEPS=pylint flask

# --config
.DEFAULT_GOAL := up


# --targets
### unprepare, prepare, reprepare, setup, run are all for local, non-containerized development
unprepare:
	brew uninstall --force $(BREW_DEPS)
	brew cask uninstall $(BREW_CASK_DEPS)

prepare:
	brew update
	brew install $(BREW_DEPS) || true
	brew cask install $(BREW_CASK_DEPS) || true
	pip3 install $(PIP_DEPS)

reprepare: unprepare prepare

setup:
	virtualenv -p python3 env
	source env/bin/activate
	pip3 install -r requirements.txt

run:
	FLASK_ENV=development FLASK_DEBUG=true python3 app.py

clean:
	rm -rf ./env/
	find . -name ".pyc" | xargs rm -rf

lint:
	pylint --disable=C0103 app.py __init__.py

run.local: lint setup run

test:
	echo && echo 
	curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/version && echo && echo
	curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:5000/tree && echo && echo
	curl -i --data "param1=value1" http://localhost:5000/tree 

### build, stop, run, and up work with a local /var/run/docker.sock
### 'stop' will stop a container named 'treepi', rename the container to something random for the next run
build:
	docker build --tag treepi:local .

stop:
	docker ps | grep 'treepi' | tr -s ' ' | cut -d' ' -f1 | xargs docker stop && sleep 3
	docker rename treepi $$(openssl rand -hex 12) || true

run:
	docker run -d --name treepi -p 5000:5000 treepi:local && sleep 3

up: build stop run test

### minikube commands follow
mkstart:
	minikube start && sleep 1

mkconfig:
	kubectl config use-context minikube
	kubectl cluster-info

mkenv:
	eval $$(minikube docker-env)	
	
mkup: mkenv build
