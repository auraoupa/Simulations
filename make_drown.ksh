#!/bin/bash

ulimit -s unlimited

for typ in gridT gridS; do

  case $typ in
    gridT) var=votemper;;
    gridS) var=vosaline;;
  esac

  for file in $(ls GLORYS2V3_NACHOS025_2010??15_R20130808_${typ}.nc); do

    ncrename -a ${var}@missing_value,${var}@_FillValue $file

    mask_drown_field.x -D -m 0 -x nav_lon -y nav_lat -z deptht -i $file -o drowned_$file -v $var -p -1

  done


done

for typ in gridT gridS; do

  case $typ in
    gridT) var=votemper;;
    gridS) var=vosaline;;
  esac

  for file in $(ls GLORYS2V3_NACHOS025_2010??15_R20140520_${typ}.nc); do

    ncrename -a ${var}@missing_value,${var}@_FillValue $file
    mask_drown_field.x -D -m 0 -x nav_lon -y nav_lat -z deptht -i $file -o drowned_$file -v $var -p -1

  done

  ncrcat -O drowned_GLORYS2V3_NACHOS025_2010??15_*_${typ}.nc drowned_GLORYS2V3_NACHOS025_2010_${typ}.nc

done

