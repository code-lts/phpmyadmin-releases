.PHONY: update-releases

update-releases:
	./scripts/update-releases.sh

update: update-releases
	@echo "Done"

push:
	@echo "Preview push"
	git push --tags --dry-run
	git push --all origin --dry-run
	@echo "Sleeping 10s so you can review before pushing"
	@sleep 10
	git push --tags
	git push --all origin
	@echo "Done."
