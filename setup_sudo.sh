#NVIDIA Jetson Setup

real_user=$(whoami)

echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
echo "export OPENBLAS_CORETYPE=ARMV8" >> ~/.bashrc

apt-get update
apt-get -y upgrade
apt-get install -y python3-pip python3-venv python3-dev python3-wheel python3-dbg cmake
pip3 install -U pip
pip3 install wget Cython

cd ~/Downloads/
apt-get install -y libboost-all-dev build-essential python-setuptools libboost-python-dev libboost-thread-dev
apt-get install -y python-numpy

# PyCUDA Installation
wget https://files.pythonhosted.org/packages/5a/56/4682a5118a234d15aa1c8768a528aac4858c7b04d2674e18d586d3dfda04/pycuda-2021.1.tar.gz
tar xzvf pycuda-2021.1.tar.gz
cd pycuda-2021.1
sudo -u $real_user ./configure.py
sudo -u $real_user make -j4
python3 setup.py install
pip3 install .

cd ~/Downloads/

# LLVM Installation
wget http://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz
tar -xvf llvm-7.0.1.src.tar.xz
cd llvm-7.0.1.src
mkdir llvm_build_dir
cd llvm_build_dir/
sudo -u $real_user cmake ../ -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"
sudo -u $real_user make -j4
make install
cd bin/
echo "export LLVM_CONFIG=\""`pwd`"/llvm-config\"" >> ~/.bashrc
echo "alias llvm='"`pwd`"/llvm-lit'" >> ~/.bashrc
source ~/.bashrc
pip3 install llvmlite==0.30.0

cd ~/Downloads/

# Numba Installation
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-10.0.1.src.tar.xz
tar -xvf llvm-10.0.1.src.tar.xz
cd llvm-10.0.1.src
mkdir llvm_build_dir
cd llvm_build_dir/
sudo -u $real_user cmake ../ -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"
sudo -u $real_user make -j4
make install
cd bin/
echo "export LLVM_CONFIG=\""`pwd`"/llvm-config\"" >> ~/.bashrc
echo "alias llvm='"`pwd`"/llvm-lit'" >> ~/.bashrc
source ~/.bashrc

cd ~/Downloads/
git clone https://github.com/wjakob/tbb.git
cd tbb/build
sudo -u $real_user cmake ..
sudo -u $real_user make -j4
make install
pip3 install protobuf==3.3.0
pip3 install llvmlite
pip3 install numba

# SciPy Installation
pip3 install 'https://github.com/jetson-nano-wheels/python3.6-scipy-1.5.4/releases/download/v0.0.1/scipy-1.5.4-cp36-cp36m-linux_aarch64.whl'

# TensorFlow Installation
apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
pip3 install -U --no-deps numpy==1.19.4 future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 protobuf pybind11 pkgconfig
pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v46 tensorflow

# Jupyter Lab Installation
pip3 install packaging
pip3 install jupyterlab
