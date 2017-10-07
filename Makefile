VOLUME=$(shell pwd)
PORT=3050
WITH_R=--volumes-from=rserve

PUBLISH=--publish=${PORT}:3050
DOPTS=${PUBLISH} -v ${VOLUME}:/data ${WITH_R}

all:
	@echo "Targets"
	@echo
	@echo "image            Build the swish image"
	@echo "run              Run the image (detached)"
	@echo "authenticated    Run the image in authenticated mode"
	@echo "add-user         Add a user for authenticated mode"
	@echo "interactive      Run the image interactively"

image:	swish
	docker build -t swish .

swish::
	if [ -d swish ]; then \
	   (cd swish && git pull) ; \
	else \
	   git clone https://github.com/SWI-Prolog/swish.git; \
	fi
	(cd swish && git submodule update --init)
	make -C swish bower-zip min packs

run:
	docker run --detach ${DOPTS} swish

authenticated:
	docker run --detach ${DOPTS} swish --authenticated

interactive:
	docker run -it ${DOPTS} swish

add-user:
	docker run -it ${DOPTS} swish --add-user

help:
	docker run -it ${DOPTS} swish --help
