#!/usr/bin/env bash


create_hifiberry_settings(){

sed -i 's!dtparam=audio=on!#dtparam=audio=on!' /boot/config.txt

echo "#dtoverlay for hifiberry" >> /boot/config.txt
echo dtparam=spi=on >> /boot/config.txt
}


hifiberry_dac(){
echo dtoverlay=hifiberry-dac >> /boot/config.txt
}
hifiberry_dacplus(){
echo dtoverlay=hifiberry-dacplus >> /boot/config.txt
}
hifiberry_digi(){
echo dtoverlay=hifiberry-digi >> /boot/config.txt
}
hifiberry_amp(){
echo dtoverlay=hifiberry-amp >> /boot/config.txt
}


# configure ALSA

configure_ALSA(){

cat <<EOF > /etc/asound.conf
pcm.!default  {
 type hw card 0
}
ctl.!default {
 type hw card 0
}
EOF
}

select_hifiberry_card(){
read -rep $'Which hifiberry card do you use? Type: 1 (hifiberry-dac), Type: 2 (hifiberry-dacplus), Type: 3 (hifiberry-digi, Type: 4 (hifiberry-amp)\n' numbers
echo $numbers
if (( $numbers > 0 )) && (( $numbers < 5 ))
then
  create_hifiberry_settings

  if [ $numbers -eq 1 ]
  then
    echo -e "create hifiberry-dac"
    hifiberry_dac

  elif [ $numbers -eq 2 ]
  then
    echo -e "create hifiberry-dacplus"
    hifiberry_dacplus

  elif [ $numbers -eq 3 ]
  then
    echo -e "create hifiberry-digi"
    hifiberry_digi
  else
   echo -e "create hifiberry-amp"
   hifiberry_amp
  fi
else
  echo -e "wrong number, please retry!"
  select_hifiberry_card
fi

}



##############main#################

echo -e "start configuration of hifiberry card"
select_hifiberry_card

echo -e "successfully configured file /boot/config.txt\n"

echo -e "configuration finished \n"
echo "reboot starts in 5 seconds"
sleep 5
sudo reboot