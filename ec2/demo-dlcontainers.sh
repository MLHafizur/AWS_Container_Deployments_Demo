export REGION=eu-west-1
export CONTAINER=763104351884.dkr.ecr.eu-west-1.amazonaws.com/tensorflow-training:1.15.2-gpu-py36-cu100-ubuntu18.04
aws configure set region $REGION

# Login to ECR repository
$(aws ecr get-login --no-include-email --registry-ids 763104351884)

# GPU-enabled container for Tensorflow 1.13
docker pull $CONTAINER

# Run an interactive session
nvidia-docker run -it $CONTAINER

*** In container

git clone https://github.com/fchollet/keras.git

python keras/examples/mnist_cnn.py


