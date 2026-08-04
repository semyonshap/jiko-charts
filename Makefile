.PHONY: help lint lint-strict deps template values clean

# Charts are discovered automatically: any directory under charts/ with a Chart.yaml
CHARTS := $(shell for d in charts/*/; do [ -f "$$d/Chart.yaml" ] && echo "$${d%/}"; done)

# App charts = charts of type "application" (excludes the `nextjs` library chart)
APP_CHARTS := $(shell for c in $(CHARTS); do grep -q '^type: application' "$$c/Chart.yaml" && echo "$$c"; done)

RELEASE_NAME ?= jiko

help: ## Show this help message
	@awk '/^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, substr($$0, index($$0, "##")+3)}' $(MAKEFILE_LIST)

deps: ## Rebuild chart dependencies (materialize `nextjs` library into app charts)
	@for c in $(APP_CHARTS); do helm dependency update "$$c"; done

lint: deps ## Lint all Helm charts
	helm lint $(CHARTS)

lint-strict: deps ## Lint all Helm charts (strict mode)
	helm lint --strict $(CHARTS)

template: deps ## Render manifests for all app charts
	@for c in $(APP_CHARTS); do helm template $(RELEASE_NAME) "$$c"; done

values: ## Show default values of all charts
	@for c in $(CHARTS); do echo "=== $$c ==="; helm show values "$$c"; done

clean: ## Remove packaged artifacts and materialized dependencies
	rm -rf .release charts/*/charts
