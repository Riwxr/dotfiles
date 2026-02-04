!# /usr/bin/env bash

z=$(rmpc song | jq -r '.metadata | "\(.title)  -  \(.artist)"')

swayosd-client --custom-message "$z"

