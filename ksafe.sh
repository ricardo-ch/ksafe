#!/bin/zsh

if [ "$1" = "reset" ]; then
    sed -i '' -e "/KSAFE_PRODUCTION_TS/s/=.*/=$(date +%s)/" ~/.ksafe/config # reset the timestamp
    shift # remove 'reset' from the args list
fi

. ~/.ksafe/config # source the configuration file

if [ -z $KSAFE_PRODUCTION_TS ]; then
    sed -i '' -e "/KSAFE_PRODUCTION_TS/s/=.*/=0/" ~/.ksafe/config # no previous timestamp found, set it to zero to force the prompt
    KSAFE_PRODUCTION_TS=0 # necessary since the config file was sourced before the ts is set to 0
fi

CTX=$(kubectl config current-context)
ELAPSED=`expr $(date +%s) - $KSAFE_PRODUCTION_TS`

if [[ $CTX =~ $KSAFE_DANGEROUS_CONTEXT ]]; then
    if [ $ELAPSED -gt $KSAFE_DELAY_S ]; then
        read -q "REPLY?/!\ You are still in an unsafe environment! Are you sure? (y/n)"
        echo # newline
        if [[ $REPLY =~ ^[^Yy]$ ]]; then
            kubectl config use-context $KSAFE_SAFE_CONTEXT # get back to safety
            return
        fi
    fi
    sed -i '' -e "/KSAFE_PRODUCTION_TS/s/=.*/=$(date +%s)/" ~/.ksafe/config  # save the new timestamp
fi

kubectl "$@" # actually execute the command, without passing the reset paramter
return