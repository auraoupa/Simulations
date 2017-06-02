#!/bin/bash



ncks -O -F -d x,2271,3879 -d y,1260,2827 /scratch/cnt0024/hmg2840/molines/ORCA12.L46/ORCA12.L46-I/ORCA12.L46-MAL95_y1998-2007m01_icemod_initMAL101.nc NACHOS12.L75_y1998-2007m01_icemod_initMAL101.nc
ncks -O -F -d XAXIS,2271,3879 -d YAXIS,1260,2827 /scratch/cnt0024/hmg2840/molines/ORCA12.L46/ORCA12.L46-I/chlaseawifs_c1m-99-05_smooth_ORCA_R12.nc chlaseawifs_c1m-99-05_smooth_NACHOS12.nc;


cp /scratch/cnt0024/hmg2840/molines/eORCA12.L75/eORCA12.L75-I/EN4.1.1_75L_monthly_19952014_reg1d_sss_noz.nc .
cp /scratch/cnt0024/hmg2840/molines/eORCA12.L75/eORCA12.L75-I/Goutorbe_ghflux.nc .

for file in eORCA12_bfr2d_UKmod.nc eORCA12.L75-G07_y1976_1m_votemper_masked.nc eORCA12.L75-G07_y1976_1m_vosaline_masked.nc eORCA12_runoff_v2.4.nc eORCA12_shlat2d_UK_Ant_Spain_mod.nc eORCA12_EN4.1.1f_reg_sss_weights_bilin.nc eORCA12_Goutorbe_weights_bilin.nc wght_DFS5_eORCA12_bicub.nc wght_DFS5_eORCA12_bilin.nc; do

  fileo=$(echo $file | sed "s/eORCA12.L75/NACHOS12.L75/g")
  fileo=$(echo $fileo | sed "s/eORCA12/NACHOS12.L75/g")

  echo $file $fileo

  case $file in
    eORCA12_EN4.1.1f_reg_sss_weights_bilin.nc|eORCA12_Goutorbe_weights_bilin.nc|wght_DFS5_eORCA12_bicub.nc|wght_DFS5_eORCA12_bilin.nc) ncks -O -F -d lon,2271,3879 -d lat,1807,3374 /scratch/cnt0024/hmg2840/molines/eORCA12.L75/eORCA12.L75-I/$file $fileo;;
    *) ncks -O -F -d x,2271,3879 -d y,1807,3374 /scratch/cnt0024/hmg2840/molines/eORCA12.L75/eORCA12.L75-I/$file $fileo;;
  esac

done



