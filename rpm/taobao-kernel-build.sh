#!/bin/bash
##for check
sudo yum -b current -y install asciidoc 
sudo yum install xmlto rng-utils m4 python26-devel python-devel perl-TimeDate binutils-devel zlib-devel elfutils-libelf-devel -y
sudo pkill -9 rngd
sudo rngd -r /dev/urandom
cd $1
echo Starting "$BUILD_NUMBER"th Taobao-kernel build.
python ./scripts/package.py --buildid $BUILD_NUMBER
cd taobao-kernel-build
rpmbuild -bb  --rmsource *.spec --without lvs --without dracut --without debug --define="_rpmdir $1/rpm" --define="_builddir $1/taobao-kernel-build" --define="_sourcedir $1/taobao-kernel-build" --define="_tmppath $1/rpm"

cd $1/rpm
find . -name "*.rpm"  -exec mv {} . \;
for mypk in `ls *.rpm`
do
	t_pk_l=${mypk//-/ }
	t_pk_array=($t_pk_l)
	ac=${#t_pk_array[*]}
	version=${t_pk_array[$ac-2]}
	echo $version > $1/rpm/$2-VER.txt
	break
done

