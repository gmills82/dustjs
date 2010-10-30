#
# Run all tests
#
test:
	node test/server.js

#
# Run the benchmarks
#
bench:
	node benchmark/server.js

#
# Build the docs
#
docs:
	node docs/build.js

#
# Build the parser
#
parser:
	node src/build.js

#
# Build dust.js
#

SRC = lib
VERSION = ${shell cat package.json | grep version | grep -o '[0-9]\.[0-9]\.[0-9]\+'}
CORE = dist/dust-core-${VERSION}.js
CORE_MIN = dist/dust-core-${VERSION}.min.js
FULL = dist/dust-full-${VERSION}.js
FULL_MIN = dist/dust-full-${VERSION}.min.js

define HEADER
//
// Dust - Asynchronous Templating v${VERSION}
// http://akdubya.github.com/dustjs
//
// Copyright (c) 2010, Aleksander Williams
// Released under the MIT License.
//

endef

export HEADER

dust:
	@@mkdir -p dist
	@@touch ${CORE}
	@@echo "$$HEADER" > ${CORE}
	@@cat ${SRC}/dust.js >> ${CORE}
	@@echo ${CORE} built
	@@touch ${FULL}
	@@echo "$$HEADER" > ${FULL}
	@@cat ${SRC}/dust.js\
	      ${SRC}/compiler.js\
	      ${SRC}/parser.js >> ${FULL}
	@@echo ${FULL} built

min: dust
	@@echo minifying...
	@@echo "$$HEADER" > ${CORE_MIN}
	@@echo "$$HEADER" > ${FULL_MIN}
	@@minmin ${CORE} >> ${CORE_MIN}
	@@minmin ${FULL} >> ${FULL_MIN}

clean:
	git rm dist/*
	git rm index.html

.PHONY: test docs bench parser