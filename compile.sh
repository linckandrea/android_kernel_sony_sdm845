mkdir -p out
make O=out clean
make O=out mrproper

branch=$(git symbolic-ref --short HEAD)
branch_name=$(git rev-parse --abbrev-ref HEAD)
last_commit=$(git rev-parse --verify --short=8 HEAD)
export LOCALVERSION="-Armonia-Kernel-${branch_name}/${last_commit}"

echo input xz3 xz2 xz2c xz2p according to the version you want to build

read version

case $version in
xz3)
echo xz3 defconfig selected
make O=out ARCH=arm64 Armonia_tama_akatsuki_defconfig
;;
xz2)
echo xz2 defconfig selected
make O=out ARCH=arm64 Armonia_tama_akari_defconfig
;;
xz2c)
echo xz2c defconfig selected
make O=out ARCH=arm64 Armonia_tama_apollo_defconfig
;;
xz2p)
echo xz2p defconfig selected
make O=out ARCH=arm64 Armonia_tama_aurora_defconfig
;;
*)
echo the input typed is wrong, compilation aborted...
return 0
;;
esac

PATH=""$HOME"/Android-dev/toolchains/aosp-clang/clang-r522817/bin:"$HOME"/Android-dev/toolchains/aosp-clang/aarch64-linux-android-4.9/bin:"$HOME"/Android-dev/toolchains/aosp-clang/arm-linux-androideabi-4.9/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      SUBARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi- \
                      HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument" \
                      LLVM=1 \
                      LLVM_IAS=1

case $version in
xz3)
rm ./AnyKernel3/akatsuki/*.zip
rm ./AnyKernel3/akatsuki/Image.gz-dtb
cp ./out/arch/arm64/boot/Image.gz-dtb ./AnyKernel3/akatsuki
cd ./AnyKernel3/akatsuki
zip -r9 ArmoniaKernel-"akatsuki"-"$branch"-"$last_commit".zip * -x .git README.md *placeholder
;;
xz2)
rm ./AnyKernel3/akari/*.zip
rm ./AnyKernel3/akari/Image.gz-dtb
cp ./out/arch/arm64/boot/Image.gz-dtb ./AnyKernel3/akari
cd ./AnyKernel3/akari
zip -r9 ArmoniaKernel-"$version"-"$branch"-"$last_commit".zip * -x .git README.md *placeholder
;;
xz2c)
rm ./AnyKernel3/apollo/*.zip
rm ./AnyKernel3/apollo/Image.gz-dtb
cp ./out/arch/arm64/boot/Image.gz-dtb ./AnyKernel3/apollo
cd ./AnyKernel3/apollo
zip -r9 ArmoniaKernel-"$version"-"$branch"-"$last_commit".zip * -x .git README.md *placeholder
;;
xz2p)
rm ./AnyKernel3/aurora/*.zip
rm ./AnyKernel3/aurora/Image.gz-dtb
cp ./out/arch/arm64/boot/Image.gz-dtb ./AnyKernel3/aurora
cd ./AnyKernel3/aurora
zip -r9 ArmoniaKernel-"$version"-"$branch"-"$last_commit".zip * -x .git README.md *placeholder
;;
*)
echo the input typed is wrong, compilation aborted...
return 0
;;
esac

cd ..
cd ..
echo THE END