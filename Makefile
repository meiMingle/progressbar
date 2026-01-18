SHELL = /bin/bash

.PHONY: build test clean javadoc docs mkdocs-serve gh-deploy-docs deploy package

# Build the project
build:
	mvn compile

# Run tests
test:
	mvn test

# Build JAR package
package:
	mvn package -DskipTests

# Generate Javadoc via Dokka
javadoc:
	mvn dokka:dokka dokka:javadoc

# Build MkDocs documentation
docs: javadoc
	mkdocs build

mkdocs-serve: docs
	mkdocs serve

# Credit to https://github.com/kg4zow/mdbook-template/blob/main/Makefile
gh-deploy-docs: docs
	set -ex ; \
	WORK="$$( mktemp -d )" ; \
	VER="$$( git describe --always --tags --dirty )" ; \
	git worktree add --force "$$WORK" gh-pages ; \
	rm -rf "$$WORK"/* ; \
	rsync -av docs/ "$$WORK"/ ; \
	if [ -f CNAME ] ; then cp CNAME "$$WORK"/ ; fi ; \
	pushd "$$WORK" ; \
	git add -A ; \
	git commit -m "Updated gh-pages $$VER" ; \
	popd ; \
	git worktree remove "$$WORK" ; \
	git push origin gh-pages


# Deploy to Maven Central
deploy:
	mvn deploy

# Clean build artifacts
clean:
	mvn clean
	rm -rf site/
