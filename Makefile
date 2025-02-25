.EXPORT_ALL_VARIABLES:

SHELL=/bin/bash -o pipefail

build:
	@docker build --pull -f Dockerfile.build --build-arg STACK=heroku-18 --build-arg BASE_IMAGE=heroku/heroku:18-build -t heroku/pack:18-build .
	@docker build --pull -f Dockerfile.build --build-arg STACK=heroku-20 --build-arg BASE_IMAGE=heroku/heroku:20-build -t heroku/pack:20-build .
	@docker build --pull -f Dockerfile.run --build-arg STACK=heroku-18 --build-arg BASE_IMAGE=heroku/heroku:18 -t heroku/pack:18 .
	@docker build --pull -f Dockerfile.run --build-arg STACK=heroku-20 --build-arg BASE_IMAGE=heroku/heroku:20 -t heroku/pack:20 .
	@pack create-builder heroku/buildpacks:18 --config builder-18.toml --pull-policy if-not-present
	@pack create-builder heroku/buildpacks:20 --config builder-20.toml --pull-policy if-not-present
	@docker tag heroku/buildpacks:20 heroku/buildpacks:latest

publish: build
	@docker push heroku/pack:18-build
	@docker push heroku/pack:20-build
	@docker push heroku/pack:18
	@docker push heroku/pack:20
	@docker push heroku/buildpacks:18
	@docker push heroku/buildpacks:20
	@docker push heroku/buildpacks:latest
