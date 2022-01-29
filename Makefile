build: prepare
	echo "Build is empty."

clean:
	rm -rf tapi llvm dyld xnu
	rm -rf include

prepare: tapi llvm dyld xnu
	echo "Prepare ended."

tapi: llvm
	mkdir -p $@
	curl -# -L https://opensource.apple.com/tarballs/tapi/tapi-1100.0.11.tar.gz | tar xz -C $@ --strip-components=1
	# curl -# -L https://github.com/apple-oss-distributions/tapi/archive/refs/tags/tapi-1100.0.11.tar.gz | tar xz -C $@ --strip-components=1
	cp $@/include/tapi/Version.inc.in $@/include/tapi/Version.inc
	# patch -R -p1 -d $@ < patches/tapi.patch

llvm:
	mkdir -p $@
	curl -# -L https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz | tar xJ -C $@ --strip-components=1

dyld:
	git clone git@github.com:apple-oss-distributions/dyld.git
	git -C $@ checkout c8a445f88f9fc1713db34674e79b00e30723e79d -f
	patch -p1 -d $@ < patches/dyld.patch

xnu:
	mkdir -p $@
	curl -# -L https://github.com/apple-oss-distributions/xnu/archive/refs/tags/xnu-8792.81.2.tar.gz | tar xz -C $@ --strip-components=1
	mkdir -p include/System/
	cp -r $@/osfmk/machine include/System/
	cp -r $@/EXTERNAL_HEADERS/corecrypto include/
