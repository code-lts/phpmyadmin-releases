.PHONY: update-releases

update-releases:
	./scripts/update-releases.sh

update: update-releases
	@echo "Done"
