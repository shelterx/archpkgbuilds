#!/bin/bash

export TOPLEV=~/toolchain/llvm
cd ${TOPLEV}

mkdir ${TOPLEV}/stage3-bolt  || (echo "Could not create stage3-bolt directory"; exit 1)
cd ${TOPLEV}/stage3-bolt
CPATH=${TOPLEV}/stage2-prof-use-lto/install/bin
BOLTPATH=${TOPLEV}/stage1/bin



echo "== Configure Build"
echo "== Build with stage2-prof-use-tools -- $CPATH"

cmake -G Ninja \
    -DLLVM_BINUTILS_INCDIR=/usr/include \
    -DCMAKE_BUILD_TYPE=Release \
        -D CMAKE_C_FLAGS=" -O3 -march=native -mllvm -polly -mllvm -polly-position=early -mllvm -polly-parallel=true -fopenmp -fopenmp-version=51 -mllvm -polly-dependences-computeout=5000000 -mllvm -polly-tiling=true -mllvm -polly-prevect-width=256 -mllvm -polly-vectorizer=stripmine -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=36 -mllvm -polly-scheduling=dynamic -mllvm -polly-scheduling-chunksize=1 -mllvm -polly-ast-use-context -mllvm -polly-invariant-load-hoisting -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fno-math-errno -fno-trapping-math -falign-functions=32 -fno-semantic-interposition -fcf-protection=none -mharden-sls=none -g0 -Wp,-D_FORTIFY_SOURCE=0" \
        -D CMAKE_CXX_FLAGS=" -O3 -march=native -mllvm -polly -mllvm -polly-position=early -mllvm -polly-parallel=true -fopenmp -fopenmp-version=51 -mllvm -polly-dependences-computeout=5000000 -mllvm -polly-tiling=true -mllvm -polly-prevect-width=256 -mllvm -polly-vectorizer=stripmine -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=36 -mllvm -polly-scheduling=dynamic -mllvm -polly-scheduling-chunksize=1 -mllvm -polly-ast-use-context -mllvm -polly-invariant-load-hoisting -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fno-math-errno -fno-trapping-math -falign-functions=32 -fno-semantic-interposition -fcf-protection=none -mharden-sls=none -g0 -Wp,-D_FORTIFY_SOURCE=0" \
        -D CMAKE_EXE_LINKER_FLAGS="-O3 -march=native -mllvm -polly -mllvm -polly-position=early -mllvm -polly-parallel=true -fopenmp -fopenmp-version=51 -mllvm -polly-dependences-computeout=5000000 -mllvm -polly-tiling=true -mllvm -polly-prevect-width=256 -mllvm -polly-vectorizer=stripmine -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=36 -mllvm -polly-scheduling=dynamic -mllvm -polly-scheduling-chunksize=1 -mllvm -polly-ast-use-context -mllvm -polly-invariant-load-hoisting -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fno-math-errno -fno-trapping-math -falign-functions=32 -fno-semantic-interposition -fcf-protection=none -mharden-sls=none -g0 -Wp,-D_FORTIFY_SOURCE=0 -Wl,-O3,-Bsymbolic-functions,--as-needed" \
        -D CMAKE_MODULE_LINKER_FLAGS="-O3 -march=native -mllvm -polly -mllvm -polly-position=early -mllvm -polly-parallel=true -fopenmp -fopenmp-version=51 -mllvm -polly-dependences-computeout=5000000 -mllvm -polly-tiling=true -mllvm -polly-prevect-width=256 -mllvm -polly-vectorizer=stripmine -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=36 -mllvm -polly-scheduling=dynamic -mllvm -polly-scheduling-chunksize=1 -mllvm -polly-ast-use-context -mllvm -polly-invariant-load-hoisting -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fno-math-errno -fno-trapping-math -falign-functions=32 -fno-semantic-interposition -fcf-protection=none -mharden-sls=none -g0 -Wp,-D_FORTIFY_SOURCE=0 -Wl,-O3,-Bsymbolic-functions,--as-needed" \
        -D CMAKE_SHARED_LINKER_FLAGS="-O3 -march=native -mllvm -polly -mllvm -polly-position=early -mllvm -polly-parallel=true -fopenmp -fopenmp-version=51 -mllvm -polly-dependences-computeout=5000000 -mllvm -polly-tiling=true -mllvm -polly-prevect-width=256 -mllvm -polly-vectorizer=stripmine -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=36 -mllvm -polly-scheduling=dynamic -mllvm -polly-scheduling-chunksize=1 -mllvm -polly-ast-use-context -mllvm -polly-invariant-load-hoisting -mllvm -polly-loopfusion-greedy -mllvm -polly-run-inliner -mllvm -polly-run-dce -fno-math-errno -fno-trapping-math -falign-functions=32 -fno-semantic-interposition -fcf-protection=none -mharden-sls=none -g0 -Wp,-D_FORTIFY_SOURCE=0 -Wl,-O3,-Bsymbolic-functions,--as-needed" \
        -D CMAKE_INSTALL_PREFIX=/usr \
        -D LLVM_BINUTILS_INCDIR=/usr/include \
        -D LLVM_BUILD_LLVM_DYLIB:BOOL=ON \
        -D LLVM_LINK_LLVM_DYLIB:BOOL=ON \
        -D CLANG_LINK_CLANG_DYLIB=ON \
        -D LLVM_BUILD_TOOLS:BOOL=ON \
        -D LLVM_BUILD_UTILS:BOOL=ON \
        -D CLANG_ENABLE_ARCMT:BOOL=OFF \
        -D CLANG_ENABLE_STATIC_ANALYZER:BOOL=OFF \
        -D COMPILER_RT_BUILD_SANITIZERS:BOOL=OFF \
        -D COMPILER_RT_BUILD_XRAY:BOOL=OFF \
        -D LLVM_INCLUDE_BENCHMARKS=OFF \
        -D LLVM_INCLUDE_GO_TESTS=OFF \
        -D LLVM_INCLUDE_TESTS=OFF \
        -D LLVM_INCLUDE_EXAMPLES=OFF \
        -D LLVM_BUILD_DOCS=OFF \
        -D LLVM_INCLUDE_DOCS=OFF \
        -D LLVM_ENABLE_OCAMLDOC=OFF \
        -D LLVM_ENABLE_SPHINX=OFF \
        -D LLVM_ENABLE_DOXYGEN=OFF \
        -D LLVM_ENABLE_BINDINGS=OFF \
        -D POLLY_ENABLE_GPGPU_CODEGEN=OFF \
        -D LLVM_ENABLE_Z3_SOLVER=OFF \
    -DCMAKE_AR=${CPATH}/llvm-ar \
    -DCMAKE_C_COMPILER=${CPATH}/clang \
    -DCLANG_TABLEGEN=${CPATH}/clang-tblgen \
    -DCMAKE_CXX_COMPILER=${CPATH}/clang++ \
    -DLLVM_USE_LINKER=${CPATH}/ld.lld \
    -DLLVM_TABLEGEN=${CPATH}/llvm-tblgen \
    -DCMAKE_RANLIB=${CPATH}/llvm-ranlib \
    -DCMAKE_PREFIX_PATH=${TOPLEV}/stage1/lib/cmake/llvm \
    -DLLVM_HOST_TRIPLE=x86_64-unknown-linux \
    -DLLVM_POLLY_LINK_INTO_TOOLS=ON \
    -DLLVM_ENABLE_RUNTIMES="openmp" \
    -DOPENMP_ENABLE_LIBOMPTARGET=OFF \
    -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;lld;polly;compiler-rt;clang-tools-extra" \
    ../llvm-project/llvm || (echo "Could not configure project!"; exit 1)

echo "== Start Training Build"
perf record -o ${TOPLEV}/perf.data --max-size=10G -F 1500 -e cycles:u -j any,u -- ninja clang || (echo "Could not build project for training!"; exit 1)

cd ${TOPLEV}

echo "Converting profile to a more aggreated form suitable to be consumed by BOLT"

${BOLTPATH}/perf2bolt ${CPATH}/clang-15 \
    -p ${TOPLEV}perf.data \
    -o ${TOPLEV}/clang-15.fdata || (echo "Could not convert perf-data to bolt for clang-15"; exit 1)

echo "Optimizing Clang with the generated profile"

${BOLTPATH}/llvm-bolt ${CPATH}/clang-15 \
    -o ${CPATH}/clang-15.bolt \
    --data ${TOPLEV}/clang-15.fdata \
    -reorder-blocks=ext-tsp \
    -reorder-functions=hfsort+ \
    -split-functions=3 \
    -split-all-cold \
    -dyno-stats \
    -icf=1 \
    -use-gnu-stack || (echo "Could not optimize binary for clang-15"; exit 1)

echo "move bolted binary to clang-15"
mv ${CPATH}/clang-15 ${CPATH}/clang-15.org
mv ${CPATH}/clang-15.bolt ${CPATH}/clang-15

echo "You can now use the compiler with export PATH=${CPATH}"
