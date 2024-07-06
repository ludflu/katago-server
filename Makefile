all:
	docker buildx build \
	--platform linux/amd64 \
	--tag katagomachine4 . \
	--load

shell:
	docker run -it katagomachine4:latest /bin/bash

#buildx:
#	docker buildx create --name mybuilder --use
#	docker buildx inspect --bootstrap


up:
	docker run -p 2178:2178 katagomachine4:latest
