@echo off

if exist structure.txt (
    del structure.txt
)

powershell -Command "Get-ChildItem -Recurse" >> structure.txt