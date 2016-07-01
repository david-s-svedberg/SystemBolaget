#!/bin/bash
cd "$(dirname "$0")"
ruby src/main.rb -p 100 --varugrupper Öl --typer Porter,Ale,Stout,Specialöl,Spontanjäst
