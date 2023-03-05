FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

WORKDIR /app

COPY requirements.txt .
COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
    # python
    python3 python3-pip python3-setuptools python3-dev \
    # OpenCV deps
    libglib2.0-0 libsm6 libxext6 libxrender1 libgl1-mesa-glx \
    # c++
    g++ \
    # others
    wget unzip && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get clean && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install .

# Ninja
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
    unzip ninja-linux.zip -d /usr/local/bin/ && \
    update-alternatives --install /usr/bin/ninja ninja /usr/local/bin/ninja 1 --force && \
    # basicsr facexlib
    python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir torch>=1.13 opencv-python>=4.7 && \
    pip3 install --no-cache-dir basicsr facexlib realesrgan

# weights
RUN mkdir -p /app/experiments/pretrained_models 
#RUN wget https://github.com/TencentARC/GFPGAN/releases/download/v0.2.0/GFPGANCleanv1-NoCE-C2.pth \
#        -P experiments/pretrained_models &&\
#    wget https://github.com/TencentARC/GFPGAN/releases/download/v0.1.0/GFPGANv1.pth \
#        -P experiments/pretrained_models

CMD ["python3", "inference_gfpgan.py", "--upscale", "2", "--test_path", "inputs/whole_imgs", "--save_root", "results"]
