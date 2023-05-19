
# Use this to control building and pushing of Docker images in a significantly less ugly fashion.
#

# Top level Makefile commands (also can build individual images with `make build-<server|daemons|webui|etc...>`)
push-all:
	$(push-fts-cron-cmd)

build-all:
	$(build-fts-cron-cmd)

build-all-nc:
	$(build-fts-cron-nc-cmd)

# Image build command definitions
define build-fts-cron-cmd =
docker build --label "maintainer=$(whoami)" -t rubin-rucio-fts-cron fts-cron
endef

define build-fts-cron-nc-cmd =
docker build --label "maintainer=$(whoami)" --no-cache -t rubin-rucio-fts-cron fts-cron
endef

# Image build command declarations
build-fts-cron:
	$(build-fts-cron-cmd)

build-fts-cron-nc:
	$(build-fts-cron-nc-cmd)

# Image push command definitions
define push-fts-cron-cmd =
	docker tag rubin-rucio-fts-cron bjwhitefnal/rubin-rucio-fts-cron:${RUBIN_RUCIO_VERSION}
	docker push bjwhitefnal/rubin-rucio-fts-cron:${RUBIN_RUCIO_VERSION}
endef

# Image push command declarations
push-fts-cron:
	$(push-fts-cron-cmd)
