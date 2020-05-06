#!/bin/bash

declare -r TRUE=0
declare -r FALSE=1

function Debug() {
  return $FALSE;
}

function getStatus() {
  BESSTATUS=`/bin/systemctl is-active besclient`
  if [ "x$BESSTATUS" == "xactive" ]; then
    return $TRUE;
  fi
  return $FALSE;
}

Debug && echo "Checking TEMClient Status"
getStatus;

if [ "x$?" == "x$TRUE" ]; then
  Debug && echo "Running"
else
  let COUNT=0;
  Debug && echo "Stopped"
  while [ $COUNT -lt 5 ];
  do
    Debug && echo "Trying to start - $COUNT"
    (/bin/systemctl start besclient --quiet) 2>&1> /dev/null
    getStatus;
    if [ "x$?" == "x$TRUE" ]; then
       Debug && echo "Started"
       exit
    fi
    let COUNT=$COUNT+1;
  done
  Debug && echo "Unable to start TEMClient"
fi

