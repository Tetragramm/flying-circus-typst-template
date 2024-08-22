root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

# generate manual
doc:
	just install-preview
	typst compile template/Main.typ template/Main.pdf --font-path fonts/

# run test suite
test *args:
	just install-preview
	typst-test run {{ args }} --font-path fonts/

# update test cases
update *args:
	typst-test update {{ args }}

# package the library into the specified destination folder
package target:
  ./scripts/package "{{target}}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@preview" prefix (for pre-release testing)
install-preview: (package "@preview")

[private]
remove target:
  ./scripts/uninstall "{{target}}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall-preview: (remove "@preview")

# run ci suite
ci: test doc