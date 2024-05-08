#!/bin/bash

# create dev predictions for every pool model
#
for encum in `cut -f2 sorted_filter_train_ids.dat`

do

  for model in `cut -f2 sorted_filter_train_ids.dat`

  do
    echo "EncNum $encum, Model $model"

    mkdir -p "data/data_$encum/"

    # enable continue when stopped
    if [ ! -f "data/data_$encum/generated_$model.dat" ]; then
      cp -a data/data_empty/* "data/data_$encum/"
      grep "^$encum" train.dat > "data/data_$encum/train.dat"

      python sepens/predict_ts.py --cuda --data "data/data_$encum" \
                          --checkpoint "models/model_$model.pt" \
                          --outf "data/data_$encum/generated_$model.dat"

      paste <(cut -f1-4 "data/data_$encum/dev.dat") \
            "data/data_$encum/generated_$model.dat" \
            > "data/data_$encum/label_pred.dat"
    fi

  done

done
