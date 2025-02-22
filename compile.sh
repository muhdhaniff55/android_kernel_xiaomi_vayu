set -e

CONFIG="vayu_user_defconfig"

build() {
    make -j$(nproc --all) O=out         \
    ARCH=arm64                          \
    SUBARCH=arm64                       \
    DTC_EXT=dtc                         \
    CROSS_COMPILE=aarch64-linux-gnu-    \
    LLVM=1                              \
    LLVM_IAS=1                          \
    LD=ld.lld                           \
    AR=llvm-ar                          \
    NM=llvm-nm                          \
    STRIP=llvm-strip                    \
    OBJCOPY=llvm-objcopy                \
    OBJDUMP=llvm-objdump                \
    READELF=llvm-readelf                \
    HOSTCC=clang                        \
    HOSTCXX=clang++                     \
    HOSTAR=llvm-ar                      \
    HOSTLD=ld.lld                       \
    CC="ccache clang"                   \
    $1
}

build "$CONFIG"

build all

if [ ! -d out/ak3 ]; then
    git clone --depth=1 https://github.com/chiteroman/AnyKernel3-vayu.git out/ak3
fi

cp out/arch/arm64/boot/Image out/ak3

cat out/arch/arm64/boot/dts/qcom/*.dtb > out/ak3/dtb

cp out/arch/arm64/boot/dtbo.img out/ak3

cd out/ak3

zip -r9 kernel.zip * -x .git README.md *placeholder *.zip
