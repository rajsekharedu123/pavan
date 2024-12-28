#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

ssh-keygen
echo 'export NAME=dawsrajs.online' >> ~/.bashrc 
echo 'export KOPS_STATE_STORE=s3://dawsrajs.online' >> ~/.bashrc 
echo 'export AWS_REGION=us-east-1' >> ~/.bashrc 
echo 'export CLUSTER_NAME=dawsrajs.online' >> ~/.bashrc 
echo 'export EDITOR='/usr/bin/nano'' >> ~/.bashrc 
echo 'alias ku=kubectl' >> ~/.bashrc 


echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'complete -o default -F __start_kubectl ku' >>~/.bashrc

cd /usr/local/bin
wget https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64
mv kops-linux-amd64 kops
chmod 700 kops
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod 700 kubectl
cd