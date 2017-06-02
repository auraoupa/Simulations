for k in $(seq 500 50 2000); do k1=`expr $k - 5`; k2=`expr $k + 5`; for  kk in $(seq $k1 $k2); do ./screen.ksh $kk | sort -k8 | head -2 | tail -1 ; done > screen_$k.txt; done

for k in $(seq 500 50 2000); do cat screen_$k.txt | sort -k8 | head -1; done > best.txt
