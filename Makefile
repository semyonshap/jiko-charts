.PHONY: help lint lint-strict deps template values ct clean

# Chart list and order (single source: charts.txt)
CHARTS := $(shell cat charts.txt)

# App charts (type: application, excludes library charts)
APP_CHARTS := $(shell for c in $(CHARTS); do grep -q '^type: application' "$$c/Chart.yaml" && echo "$$c"; done)

RELEASE_NAME ?= jiko

help: ## Show this help message
	@awk '/^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, substr($$0, index($$0, "##")+3)}' $(MAKEFILE_LIST)

deps: ## Rebuild chart dependencies in topological order
	@for c in $(CHARTS); do echo ">>> helm dependency update $$c"; helm dependency update "$$c"; done

lint: deps ## Lint all Helm charts
	helm lint $(CHARTS)

lint-strict: deps ## Lint all Helm charts (strict mode)
	helm lint --strict $(CHARTS)

template: deps ## Render manifests for all app charts
	@for c in $(APP_CHARTS); do helm template $(RELEASE_NAME) "$$c"; done

values: ## Show default values of all charts
	@for c in $(CHARTS); do echo "=== $$c ==="; helm show values "$$c"; done

ct: deps ## Run chart-testing lint on changed charts
	docker run --rm \
		-v "$(CURDIR):/workdir" \
		-w //workdir \
		-e GIT_CONFIG_COUNT=1 \
		-e GIT_CONFIG_KEY_0=safe.directory \
		-e GIT_CONFIG_VALUE_0=/workdir \
		quay.io/helmpack/chart-testing:v3.14.0 \
		ct lint --target-branch main --remote origin --check-version-increment --chart-dirs charts

clean: ## Remove packaged artifacts and materialized dependencies
	rm -rf .release charts/*/charts
