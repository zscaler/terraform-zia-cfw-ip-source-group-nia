#!/bin/bash
sleep 2
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
"./ziaActivator_linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
"./ziaActivator_osx"
fi
