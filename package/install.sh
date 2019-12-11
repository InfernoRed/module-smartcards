#!/bin/bash

PACKAGE_NAME='module-smartcard'
SERVICE_NAME='module-smartcard.service'

echo "installing SmartCard dependencies"

command -v python3.7 >/dev/null 2>&1 || {
    echo "python3.7 not found. installing."
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:deadsnakes/ppa
    sudo apt-get update
    sudo apt-get install -y python3.7 python3.7-dev python3-pip
    sudo apt-get install -y libusb-1.0-0-dev libpcsclite-dev pcscd pcsc-tools swig  
}

python3.7 --version
pip3 --version

command -v pipenv >/dev/null 2>&1 || { 
    echo "pipenv not found. Installing."
    python3 -m pip install pipenv
    sudo ln -sf $(command -v pipenv) /usr/bin/pipenv
}

echo "stopping SmartCard services"
sudo systemctl stop $SERVICE_NAME
sudo systemctl disable $SERVICE_NAME
sudo rm -rf /etc/systemd/system/$SERVICE_NAME

if [ ! -d "/bin/$PACKAGE_NAME" ]; then
        sudo mkdir /bin/$PACKAGE_NAME
fi

sudo rm -rf /bin/$PACKAGE_NAME/*

sudo tar -zxvf $PACKAGE_NAME.tar.gz -C /bin/$PACKAGE_NAME/

sudo chmod -R 777 /bin/$PACKAGE_NAME

cd /bin/$PACKAGE_NAME

python3 -m pipenv install

sudo cp /bin/$PACKAGE_NAME/$SERVICE_NAME /etc/systemd/system/$SERVICE_NAME
sudo chmod 644 /lib/systemd/system/$SERVICE_NAME

echo "reloading services"
sudo systemctl daemon-reload
sudo systemctl reset-failed

echo "enabling services"
sudo systemctl enable $SERVICE_NAME

echo "starting SmartCard services"
sudo systemctl start $SERVICE_NAME
systemctl status $SERVICE_NAME --no-pager

echo "done"