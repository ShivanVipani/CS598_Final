#!/bin/bash

# create test predictions for every ensemble model
#
for encnum in `cat sorted_filter_train_ids.dat`

do

  # ensemble models
  for model in 11924 12302

  do
    echo "EncNum $encnum, Model $model"

    mkdir -p "data/data_$encnum/"
    cp -a data/data_empty/* "data/data_$encnum/"
  
    # enable continue when stopped
    if [ ! -f "data/data_$encnum/generated_$model.dat" ]; then
      grep "^$encnum" train.dat > "data/data_$encnum/train.dat"

      python sepens/predict_ts.py --cuda --data "data/data_$encnum" \
                           --checkpoint "models/model_$model.pt" \
                           --outf "data/data_$encnum/generated_$model.dat"

      paste <(cut -f1-4 "data/data_$encnum/test.dat") \
            "data/data_$encnum/generated_$model.dat" \
            > "data/data_$encnum/label_pred.dat"
    fi

  done

done

