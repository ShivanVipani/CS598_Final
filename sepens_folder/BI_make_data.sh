#!/bin/bash

if [ -z "$1" ]; then
  echo "USAGE . ./make_data.sh splitnum"
else

SPLIT=$1

if [[ -f ./sepsis_partition-E.tsv && \
      -f ./sepsis_partition-F.tsv ]]; then
    echo "INFO: Data files exist, generating train/dev/test splits..."

    tmpfile=$(mktemp /tmp/abc-script.XXXXXX)

    if [ $SPLIT=0 ]; then
    
    # Split 0
    CNT=$(($(wc -l sepsis_partition-E.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-E.tsv > "$tmpfile"
    sort -k1n "$tmpfile" > train.dat
   
    CNT=$(($(wc -l sepsis_partition-F.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-F.tsv > dev.dat
   
    CNT=$(($(wc -l sepsis_partition-F.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-F.tsv > test.dat

    elif [ $SPLIT=1 ]; then
    
    # Split 1
    CNT=$(($(wc -l sepsis_partition-F.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-F.tsv > "$tmpfile"
    sort -k1n "$tmpfile" > train.dat
   
    CNT=$(($(wc -l sepsis_partition-E.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-E.tsv > dev.dat
   
    CNT=$(($(wc -l sepsis_partition-E.tsv | awk '{print $1}')-1))
    tail -n $CNT sepsis_partition-E.tsv > test.dat

    else 
        echo "ERROR: Split number out of range [0-3]."
    fi
    rm "$tmpfile"

    cut -f1 test.dat | uniq -c | sort -rn | sed 's/  */	/g' | sed 's/^	//'  > sorted_test_ids.dat
    cut -f1 dev.dat | uniq -c | sort -rn | sed 's/  */	/g' | sed 's/^	//' > sorted_dev_ids.dat
    cut -f1 train.dat | uniq -c | sort -rn | sed 's/  */	/g' | sed 's/^	//' > sorted_train_ids.dat

    . ./sepens/print_dev_ids.sh ${SPLIT}
    . ./sepens/print_test_ids.sh ${SPLIT}

    # Prepare data directory template
    mkdir -p data/data_empty
    ln -s train.dat data/data_empty/dev.dat
    ln -s train.dat data/data_empty/test.dat
    
    # Create other directories
    mkdir logs
    mkdir models

else
    echo "ERROR: Please extract the data archive 'SepsisExp.tar.gz' into the current directory."
fi

fi
