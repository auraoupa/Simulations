#!/bin/bash


for typ in gridT gridS gridUV; do

  for file in $(ls *${typ}*); do

    fileo=$(echo $file | sed "s/GLORYS2V3_NACHOS025_/GLORYS2V3_NACHOS025_vertext_/g")

    case $typ in
      gridT) var="votemper";;
      gridS) var="vosaline";;
      gridUV) var1="vomecrty";var2="vozocrtx";;
    esac

    case $typ in
      gridT|gridS) ic_field_vertical_extent $file $var; mv ${file}_copy $fileo;;
      gridUV) ic_field_vertical_extent $file $var1; ic_field_vertical_extent ${file}_copy $var2; mv ${file}_copy_copy $fileo;;
    esac

  done

done

