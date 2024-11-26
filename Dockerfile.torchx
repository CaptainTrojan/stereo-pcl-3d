ARG PYTORCH="2.3.0"
ARG CUDA="11.8"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1"

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MMEngine, MMCV and MMDetection+3D
RUN pip install --upgrade pip
RUN pip install -U openmim
RUN mim install mmengine
RUN mim install 'mmcv>=2.0.0rc4, <2.2.0' 'mmdet>=3.0.0' #'mmdet3d>=1.1.0'

# Install mmdeploy
# clone mmdeploy to get the deployment config. `--recursive` is not necessary
RUN cd /workspace
RUN git clone -b main https://github.com/open-mmlab/mmdeploy.git
RUN cd mmdeploy && pip install -v -e .

# Add our edited mmdetection3d repo in
RUN git clone -b main https://github.com/CaptainTrojan/mmdetection3d.git /workspace/mmdetection3d \
    && cd /workspace/mmdetection3d \
    && git checkout 578ae9db21df30b2fd8ff982b0ed79367757c78a
RUN cd /workspace/mmdetection3d && pip install -v -e .
# Install some required packages
RUN pip install openxlab onnxruntime==1.15.0 mlflow google-cloud-storage gcsfs==2023.1.0 openvino-dev[onnx]==2022.3.0
WORKDIR /workspace/mmdetection3d/

# MOVED TO ENTRYPOINT SCRIPT
# # Copy KITTI data into the container
# COPY KITTI_smaller data/kitti

# # Create KITTI with stereo PCL by symlinking all the directories into data/kitti-stereo-pcl, except for 'velodyne',
# # which will be replaced with the stereo PCL data 'stereo_pcl'.
# # Train
# RUN mkdir -p data/kitti-stereo-pcl/training
# RUN mkdir -p data/kitti-stereo-pcl/testing
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/calib data/kitti-stereo-pcl/training/calib
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/image_2 data/kitti-stereo-pcl/training/image_2
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/image_3 data/kitti-stereo-pcl/training/image_3
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/label_2 data/kitti-stereo-pcl/training/label_2
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/planes data/kitti-stereo-pcl/training/planes
# RUN ln -s /workspace/mmdetection3d/data/kitti/training/stereo_pcl data/kitti-stereo-pcl/training/velodyne
# # Test
# RUN ln -s /workspace/mmdetection3d/data/kitti/testing/calib data/kitti-stereo-pcl/testing/calib
# RUN ln -s /workspace/mmdetection3d/data/kitti/testing/image_2 data/kitti-stereo-pcl/testing/image_2
# RUN ln -s /workspace/mmdetection3d/data/kitti/testing/image_3 data/kitti-stereo-pcl/testing/image_3
# RUN ln -s /workspace/mmdetection3d/data/kitti/testing/planes data/kitti-stereo-pcl/testing/planes
# RUN ln -s /workspace/mmdetection3d/data/kitti/testing/stereo_pcl data/kitti-stereo-pcl/testing/velodyne
# # ImageSets
# RUN ln -s /workspace/mmdetection3d/data/kitti/ImageSets data/kitti-stereo-pcl/ImageSets

# # Preprocess KITTI for mmdet3d
# RUN python tools/create_data.py kitti --root-path ./data/kitti --out-dir ./data/kitti --extra-tag kitti --with-plane

# # Preprocess KITTI for mmdet3d with stereo PCL
# RUN python tools/create_data.py kitti --root-path ./data/kitti-stereo-pcl --out-dir ./data/kitti-stereo-pcl --extra-tag kitti --with-plane

# Copy google credentials in
COPY google-creds.json /var/secrets/google-creds.json
ENV GOOGLE_APPLICATION_CREDENTIALS /var/secrets/google-creds.json
ENV GOOGLE_CLOUD_PROJECT easyml-394818

# Copy the entrypoint script
COPY entrypoint.sh /workspace/mmdetection3d/entrypoint.sh
COPY entrypoint.py /workspace/mmdetection3d/entrypoint.py
COPY download_from_gcs.py /workspace/mmdetection3d/download_from_gcs.py

# Run training, export, and logging
CMD ["bash", "entrypoint.sh"]
