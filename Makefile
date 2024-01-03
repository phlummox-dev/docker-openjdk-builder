
default:
	echo pass

NAME=phlummox/jammy-openjdk-builder
TAG=0.1

build:
	docker build -t  $(NAME):$(TAG) .

run:
	docker -D run -it --rm  --net=host  \
			-v $$PWD:/work --workdir /work \
	    $(NAME):$(TAG) 

