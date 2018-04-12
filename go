#! /bin/bash

exec busted . --verbose --lpath='./lib/?.lua;./lib/?/init.lua' "$@"
