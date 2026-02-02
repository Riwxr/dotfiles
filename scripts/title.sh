!#/usr/bin/env bash

swayosd-client --custom-message $(rmpc song | jq -r '.metadata | "\(.title)  -  \(.artist)"')
