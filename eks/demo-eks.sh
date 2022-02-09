export REGION=eu-west-1
export KEY_NAME=admin

aws configure set region $REGION

eksctl version

eksctl create cluster \
--name demo-eks \
--version 1.15 \
--nodegroup-name cpu-workers \
--node-type c5.2xlarge \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--ssh-access \
--ssh-public-key=$KEY_NAME

eksctl create nodegroup \
--cluster demo-eks \
--name gpu-workers \
--node-type p2.xlarge \
--nodes 2 

kubectl https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/master/nvidia-device-plugin.yml

kubectl get svc

eksctl get nodegroup --name=cpu-workers --cluster=demo-eks

eksctl get nodegroup --name=gpu-workers --cluster=demo-eks

kubectl apply -f nvidia-smi.yaml

kubectl get pod nvidia-smi

kubectl logs nvidia-smi

kubectl apply -f eks-tf-training-gpu.yaml

kubectl get pod tensorflow-training

kubectl logs tensorflow-training

eksctl delete cluster --name demo-eks

