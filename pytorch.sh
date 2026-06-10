# PyTorch
# https://pytorch.org/get-started/locally/

# 官方源
pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu132

# 上海交通大学 镜像站
pip3 install torch torchvision --index-url https://mirror.sjtu.edu.cn/pytorch-wheels/cu132

# 检查
python -c "import torch; print('GPU:', torch.cuda.get_device_name(0)) if torch.cuda.is_available() else print('CPU only')"
