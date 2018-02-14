#!/bin/bash


can0_settings(){

echo "#CAN0 settings" >> /boot/config.txt
echo dtparam=spi=on >> /boot/config.txt
echo dtoverlay=mcp2515-can0,oscillator=16000000,interrupt=25 >> /boot/config.txt
echo dtoverlay=spi-bcm2835-overlay >> /boot/config.txt

echo -e "successfully configured CAN0 in /boot/config.txt\n"
}

create_can0_if(){
if grep -q 'auto can0' /etc/network/interfaces;
then
  echo -e "CAN0 already set in /etc/network/interfaces\n"
else
  echo >> /etc/network/interfaces
  echo "#set up can0 interface" >> /etc/network/interfaces
  echo auto can0 >> /etc/network/interfaces
  echo iface can0 inet manual >> /etc/network/interfaces
  echo pre-up /sbin/ip link set can0 type can bitrate 500000 >> /etc/network/interfaces
  echo up /sbin/ifconfig can0 up >> /etc/network/interfaces
  echo down /sbin/ifconfig can0 down >> /etc/network/interfaces

  echo -e "successfully configured CAN0 in /etc/network/interfaces\n"
fi
}




can1_settings(){

echo "#CAN1 settings" >> /boot/config.txt
echo dtoverlay=mcp2515-can1,oscillator=16000000,interrupt=24 >> /boot/config.txt
echo dtoverlay=spi-bcm2835-overlay >> /boot/config.txt

echo -e "successfully configured CAN1 in /boot/config.txt\n"
}

create_can1_if(){
if grep -q 'auto can1' /etc/network/interfaces;
then
  echo -e "CAN1 already set in /etc/network/interfaces\n"
else
  echo "#set up can1 interface" >> /etc/network/interfaces
  echo auto can1 >> /etc/network/interfaces
  echo iface can1 inet manual >> /etc/network/interfaces
  echo pre-up /sbin/ip link set can1 type can bitrate 500000 >> /etc/network/interfaces
  echo up /sbin/ifconfig can1 up >> /etc/network/interfaces
  echo down /sbin/ifconfig can1 down >> /etc/network/interfaces

  echo -e "successfully configured CAN1 in /etc/network/interfaces\n"
fi
}




read_can_numbers(){
read -rep $'how many interfaces do you want to create? Type: 1 (only can0), type: 2 (can0 and can1)\n' numbers
echo $numbers
if (( $numbers > 0 )) && (( $numbers < 3 ))
then
  if [ $numbers -eq 1 ]
  then
    echo -e "create CAN0"
    can0_settings
    create_can0_if
  else
    echo -e "create CAN0 and CAN1"
    can0_settings
    create_can0_if
    can1_settings
    create_can1_if
  fi
else
  echo -e "wrong number, please retry!"
  read_can_numbers
fi
}


###############main######################

echo -e "create can interfaces \n"

read_can_numbers


