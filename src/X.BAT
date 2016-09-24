@echo off
tasm fst 
tasm test /m
tlink test+fst
