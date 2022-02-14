# BEFORE RUNNING!!
# Update ~/.bashrc file
# Add the following two lines to the end of the file
# export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
# export LD_LIBRARY_PATH=/usr/local/cuda/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

real_user=$(whoami)

apt-get update
apt-get -y upgrade
apt-get install -y python3-pip python3-venv python3-dev python3-wheel python3-dbg cmake
pip3 install -U pip
pip3 install wget Cython


cd Downloads/
apt-get install -y libboost-all-dev build-essential python-setuptools libboost-python-dev libboost-thread-dev
apt-get install -y python-numpy

wget https://files.pythonhosted.org/packages/5a/56/4682a5118a234d15aa1c8768a528aac4858c7b04d2674e18d586d3dfda04/pycuda-2021.1.tar.gz
tar xzvf pycuda-2021.1.tar.gz
cd pycuda-2021.1
sudo -u $real_user ./configure.py
sudo -u $real_user make -j4
python3 setup.py install
pip3 install .

cd ~/Downloads/

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
