#!/bin/bash
cd `dirname $0`
if [ $# != 4 ] ; then 
    echo "USAGE: ./deploy.sh  --key=vendorKey --sign=signature --port=port  --path=mp4_path" 
    echo "deploy failed"
    exit 1; 
fi
if [ "`which pip`" == '' ]; then
    sudo apt-get update
    sudo apt-get install -y python-pip
fi
if [ "`python -c 'import tornado' 2>&1`" != '' ]; then
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    sudo apt-get update
    sudo apt-get install -y libssl-dev
    sudo pip install tornado
fi
AGORA_FILE_ROOT=`pwd`
for i in "$@"
do
case $i in
    --key*)
    VENDORKEY="${i#*=}"
    shift # past argument
    ;;
    --sign*)
    VENDORSIGN="${i#*=}"
    shift # past argument
    ;;
    --port*)
    PORT="${i#*=}"
    shift # past argument
    ;;
    --path*)
    AGORA_FILE_ROOT="${i#*=}"
    shift # past argument
    ;;
esac
done

sudo chmod a+x ./agora_recording.exe
sudo cp ffmpeg /usr/local/bin/ -fv

echo '#!/bin/bash
python '"`pwd`/agora_transcode_mp4.py $AGORA_FILE_ROOT 2>&1 >>/var/log/agora_hourly.log" | sudo tee /etc/cron.hourly/agora_hourly 
sudo chmod 777 /etc/cron.hourly/agora_hourly

pid=`sudo netstat -lnp  | grep $PORT | grep -v grep | awk '{print $7}' | awk -F/ '{print $1}'`
if [ "$pid" != '' ]; then
    kill $pid
fi
#if [ ! -f  ~/.bashrc ];then
    #touch ~/.bashrc 
#fi
#sed -i "/export AGORA_FILE_ROOT=/d" ~/.bashrc
#echo "export AGORA_FILE_ROOT=$AGORA_FILE_ROOT" >>~/.bashrc
AGORA_FILE_ROOT=$AGORA_FILE_ROOT VENDORKEY=$VENDORKEY VENDORSIGN=$VENDORSIGN PORT=$PORT nohup python agora_recording_service.py  > ars.log 2>&1 &
for x in `seq 0 5`
do
    pid=`sudo netstat -lnp  | grep $PORT | grep -v grep | awk '{print $7}' | awk -F/ '{print $1}'`
    if [ "$pid" != "" ] ; then
        echo "deploy successfully"
        exit
    else
        sleep 1
    fi
done
echo "deploy failed"
