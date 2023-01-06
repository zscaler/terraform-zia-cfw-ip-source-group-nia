#!/bin/bash
sleep 2
if [[ "$OSTYPE" == "linux"* ]]; then
"sh -c ./ziaActivator_linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
"sh -c ./ziaActivator_osx"
fi
