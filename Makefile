clean:
	@ rm -rf client/build client/coverage
	@ rm -rf functions/coverage


nsp:
	@ cd functions && \
	  yarn run nsp

lint:
	@ cd functions && \
	  yarn run lint

test:
	@ cd functions && \
	  yarn run test

test-client:
	@ cd client && \
	  yarn run test -- --coverage


.PHONY: clean
.PHONY: nsp lint test test-client
