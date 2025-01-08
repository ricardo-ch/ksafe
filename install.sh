#!/bin/zsh
echo "create the ksafe directory"
mkdir ~/.ksafe
echo "copy ksafe files"
cp ksafe.sh ~/.ksafe
cp config ~/.ksafe
echo "making the ksafe shell executable"
chmod +x ~/.ksafe
if [ ! -d /usr/lical/bin ];
    then mkdir /usr/local/bin
fi
ln ksafe.sh /usr/local/bin/ksafe
echo "install complete!"