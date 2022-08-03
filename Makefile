.PHONY: build_then_install
build_then_install:
	make build && make install

.PHONY: build
build:
	cmake --build build -j 8

.PHONY: clean
clean:
	rm -rf build

.PHONY: init
init:
	cmake -S . -B build

.PHONY: install
install:
	cmake --install build --prefix .

.PHONY: run
run:
	cd bin && ./dungeons
