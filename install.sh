#!/bin/zsh
echo "create the ksafe directory"
mkdir ~/.ksafe
echo "copy ksafe files"
cp ksafe.sh ~/.ksafe
cp config ~/.ksafe
echo "making the ksafe shell executable"
chmod +x ~/.ksafe
ln ksafe.sh /usr/local/bin/ksafe
echo "install complete!"