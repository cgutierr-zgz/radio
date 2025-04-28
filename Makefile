SHELL = /bin/bash

.PHONY: run
run:  ## Run the flutter app
	flutter run

.PHONY: test
test:  ## Run the flutter tests
	flutter test

.PHONY: gen
gen:  ## Generate Dart code
	dart run build_runner build --delete-conflicting-outputs

.PHONY: watch
watch:  ## Generate Dart code in watch mode
	dart run build_runner watch --delete-conflicting-outputs

.PHONY: clean
clean:  ## Clean generated files
	dart run build_runner clean