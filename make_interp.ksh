#!/bin/bash


year=2010

for date in 0215 0315 0415 0515 0615 0715 0815 0915 1015 1115 1215; do

for typ in gridT gridS; do

  for file in $(ls ../data/${year}/GLORYS2V3_NACHOS025_vertext_${year}${date}*${typ}*) ; do


    case $typ in
      gridT) var="votemper";units="degree_Celsius";name="Temperature";;
      gridS) var="vosaline";units="PSU";name="Salinity";;
    esac

    cp namelist_3D namelist_tmp

    sed -e "s@FILE@$file@g" namelist_tmp > ztmp
   
    sed -i "s/VAR/$var/g" ztmp
    sed -i "s/UNITS/$units/g" ztmp
    sed -i "s/NAME/$name/g" ztmp 
    sed -i "s/DATE/$date/g" ztmp
    mv ztmp namelist_${var}${date}

    cp tmp_mk_sosie.ksh mk_sosie_${var}${date}.ksh

    sed -i "s/NAMELIST/namelist_${var}${date}/g" mk_sosie_${var}${date}.ksh

    sbatch mk_sosie_${var}${date}.ksh


  done

done

for var in iicethic ileadfra; do

  for file in $(ls ../data/${year}/GLORYS2V3_NACHOS025_${year}${date}*icemod*); do

    case $var in
      iicethic) units=""; name="Sea ice thickness";;
      ileadfra) units=""; name="Ice concentration";;
    esac

    cp namelist_2D namelist_tmp

    sed -e "s@FILE@$file@g" namelist_tmp > ztmp

    sed -i "s/VAR/$var/g" ztmp
    sed -i "s/UNITS/$units/g" ztmp
    sed -i "s/NAME/$name/g" ztmp
    sed -i "s/DATE/$date/g" ztmp
    mv ztmp namelist_${var}

    cp tmp_mk_sosie.ksh mk_sosie_${var}${date}.ksh
    sed -i "s/NAMELIST/namelist_${var}${date}/g" mk_sosie_${var}${date}.ksh
    sbatch mk_sosie_${var}${date}.ksh


  done

done

done
