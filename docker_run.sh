docker run --rm -it \
  --gpus all \
  --name gfpgan \
  --volume $HOME/Pictures/inputs:/app/inputs \
  --volume $HOME/Pictures/results:/app/results \
  --volume ./gfpgan/weights/:/app/gfpgan/weights/ \
  --volume ./pretrained_models:/app/experiments/pretrained_models \
  akitaonrails/gfpgan:latest $@
