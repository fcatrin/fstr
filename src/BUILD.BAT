@echo off
tasm fst 
tasm fstr /m
tlink fstr+fst
