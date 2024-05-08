#!/bin/bash

# create test predictions for ensembles (uniform+weighted)
#
for encnum in `cat sorted_filter_train_ids.dat`

do

  echo "EncNum $encnum"

  mkdir -p "data/data_$encnum/"
  cp -a data/data_empty/* "data/data_$encnum/"

  grep "^$encnum" train.dat > "data/data_$encnum/train.dat"

  python sepens/ensemble_predictions.py $encnum > "data/data_$encnum/ensemble_test.dat"

done

