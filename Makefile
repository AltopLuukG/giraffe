nodebin := ./node_modules/.bin
srcfiles := $(shell find src)

build: dist

test: node_modules
	$(nodebin)/eslint 'src/**/*.{ts,tsx}'
	$(nodebin)/tsc --noEmit
	$(nodebin)/jest

clean:
	rm -rf dist node_modules

publish: node_modules test build
	@git symbolic-ref HEAD | grep master  # Assert current branch is master
	$(nodebin)/bump --commit "Release v%s" --tag "v%s" --push
	npm publish --access=public

dist: node_modules $(srcfiles)
	@rm -rf dist
	$(nodebin)/tsc

node_modules:
	npm install

.PHONY: clean test build publish
