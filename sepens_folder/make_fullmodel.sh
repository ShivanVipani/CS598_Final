#!/bin/bash

python sepens/main_ts.py --data "." --save "models/model_all_mixed.pt" --cuda --epochs 10 2>&1 | tee "logs/training_all_mixed.log"

