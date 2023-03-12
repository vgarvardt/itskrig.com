build:
	docker build --platform linux/amd64 --no-cache --pull -t vgarvardt/itskrig.com .

run:
	docker run -it -p 8080:8080 vgarvardt/itskrig.com server

push:
	docker push vgarvardt/itskrig.com
