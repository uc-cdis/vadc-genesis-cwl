# ARG itag=latest
# ARG base_name=r-4.4.0-mkl
# ARG git_branch=master
# FROM my_r_mkl_image:latest

# ARG git_branch

# # Install required system dependencies
# RUN apt-get update && \
#     apt-get install -y \
#     cmake \
#     libcurl4-gnutls-dev \
#     libssl-dev \
#     libxml2-dev \
#     libgit2-dev \
#     gfortran \
#     build-essential \
#     software-properties-common && \
#     add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
#     apt-get update && \
#     apt-get install -y gcc-8 g++-8 && \
#     update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 && \
#     update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 60

# # Create Makevars file to set C++17 compiler
# RUN mkdir -p ~/.R && \
#     echo "CXX17 = g++" >> ~/.R/Makevars && \
#     echo "CXX17STD = -std=c++17" >> ~/.R/Makevars && \
#     echo "CXX17FLAGS = -fPIC" >> ~/.R/Makevars

# # Install Bioconductor packages and R libraries
# RUN R -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')"
# RUN R -e "BiocManager::install(c( 'SNPRelate','SeqArray', 'Rsamtools'))"

# # Install PLINK
# WORKDIR /opt/plink
# RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip \
#     && unzip plink_linux_x86_64_20230116.zip \
#     && mv plink /usr/local/bin/ \
#     && chmod +x /usr/local/bin/plink \
#     && rm plink_linux_x86_64_20230116.zip

# # Install Python and virtual environment support
# RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && apt-get clean

# # Set up a Python virtual environment
# RUN python3 -m venv /mnt/data/fan/myenv
# RUN /mnt/data/fan/myenv/bin/pip install --upgrade pip

# # Create necessary directories for workflow
# RUN mkdir -p /mnt/data/fan

# # Define environment variables
# ENV PATH="/usr/local/bin:/mnt/data/myenv/bin:$PATH"

# # Set work directory
# WORKDIR /mnt/data

# # Default command
# CMD ["/bin/bash"]


# Base image
# ARG itag=latest
# ARG base_name=r-4.4.0-mkl
# ARG git_branch=master
# FROM my_r_mkl_image:latest

# ARG git_branch

# # Install required system dependencies
# RUN apt-get update && \
#     apt-get install -y \
#     cmake \
#     libcurl4-gnutls-dev \
#     libssl-dev \
#     libxml2-dev \
#     libgit2-dev \
#     gfortran \
#     build-essential \
#     software-properties-common \
#     wget \
#     unzip \
#     jq && \
#     apt-get clean

# # Add toolchain for GCC-8
# RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
#     apt-get update && \
#     apt-get install -y gcc-8 g++-8 && \
#     update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 && \
#     update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 60

# # Create Makevars file to set C++17 compiler
# RUN mkdir -p ~/.R && \
#     echo "CXX17 = g++" >> ~/.R/Makevars && \
#     echo "CXX17STD = -std=c++17" >> ~/.R/Makevars && \
#     echo "CXX17FLAGS = -fPIC" >> ~/.R/Makevars

# # Install Bioconductor packages and R libraries
# RUN R -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')"
# RUN R -e "BiocManager::install(c('SNPRelate','SeqArray', 'Rsamtools'))"

# # Install PLINK
# WORKDIR /opt/plink
# RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip \
#     && unzip plink_linux_x86_64_20230116.zip \
#     && mv plink /usr/local/bin/ \
#     && chmod +x /usr/local/bin/plink \
#     && rm plink_linux_x86_64_20230116.zip

# # Install Python and virtual environment support
# RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && apt-get clean

# # Set up a Python virtual environment
# RUN python3 -m venv /mnt/data/fan/myenv
# RUN /mnt/data/fan/myenv/bin/pip install --upgrade pip

# # Create necessary directories for workflow
# RUN mkdir -p /mnt/data/fan

# # Install METAL
# WORKDIR /opt/metal
# RUN wget https://github.com/statgen/METAL/archive/refs/tags/2020-05-05.tar.gz -O metal.tar.gz && \
#     tar -xzvf metal.tar.gz && \
#     cd METAL-2020-05-05 && \
#     mkdir build && cd build && \
#     cmake -DCMAKE_BUILD_TYPE=Release .. && \
#     make && \
#     make test && \
#     make install && \
#     mv bin/metal /usr/local/bin/ && \
#     cd ../../ && \
#     rm -rf METAL-2020-05-05 metal.tar.gz

# # Define environment variables
# ENV PATH="/usr/local/bin:/mnt/data/myenv/bin:$PATH"

# # Set work directory
# WORKDIR /mnt/data

# # Default command
# CMD ["/bin/bash"]

# Base image
# ARG itag=latest
# ARG base_name=r-4.4.0-mkl
# ARG git_branch=master
# FROM my_r_mkl_image:latest

# ARG git_branch

# # Install required system dependencies
# RUN apt-get update && \
#     apt-get install -y \
#     cmake \
#     libcurl4-gnutls-dev \
#     libssl-dev \
#     libxml2-dev \
#     libgit2-dev \
#     gfortran \
#     build-essential \
#     software-properties-common \
#     wget \
#     unzip \
#     jq && \
#     apt-get clean

# # Upgrade bash to version 5
# RUN wget http://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz && \
#     tar -xzf bash-5.2.tar.gz && \
#     cd bash-5.2 && \
#     ./configure --prefix=/usr && \
#     make && \
#     make install && \
#     cd .. && \
#     rm -rf bash-5.2 bash-5.2.tar.gz

# # Add toolchain for GCC-8
# RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
#     apt-get update && \
#     apt-get install -y gcc-8 g++-8 && \
#     update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 && \
#     update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 60

# # Create Makevars file to set C++17 compiler
# RUN mkdir -p ~/.R && \
#     echo "CXX17 = g++" >> ~/.R/Makevars && \
#     echo "CXX17STD = -std=c++17" >> ~/.R/Makevars && \
#     echo "CXX17FLAGS = -fPIC" >> ~/.R/Makevars

# # Install Bioconductor packages and R libraries
# RUN R -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')"
# RUN R -e "BiocManager::install(c('SNPRelate','SeqArray', 'Rsamtools'))"

# # Install PLINK
# WORKDIR /opt/plink
# RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip \
#     && unzip plink_linux_x86_64_20230116.zip \
#     && mv plink /usr/local/bin/ \
#     && chmod +x /usr/local/bin/plink \
#     && rm plink_linux_x86_64_20230116.zip

# # Install Python and virtual environment support
# RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && apt-get clean

# # Set up a Python virtual environment
# RUN python3 -m venv /mnt/data/fan/myenv
# RUN /mnt/data/fan/myenv/bin/pip install --upgrade pip

# # Create necessary directories for workflow
# RUN mkdir -p /mnt/data/fan

# # Install METAL
# WORKDIR /opt/metal
# RUN wget https://github.com/statgen/METAL/archive/refs/tags/2020-05-05.tar.gz -O metal.tar.gz && \
#     tar -xzvf metal.tar.gz && \
#     cd METAL-2020-05-05 && \
#     mkdir build && cd build && \
#     cmake -DCMAKE_BUILD_TYPE=Release .. && \
#     make && \
#     make test && \
#     make install && \
#     mv bin/metal /usr/local/bin/ && \
#     cd ../../ && \
#     rm -rf METAL-2020-05-05 metal.tar.gz

# # Define environment variables
# ENV PATH="/usr/local/bin:/mnt/data/myenv/bin:$PATH"

# # Set work directory
# WORKDIR /mnt/data

# # Default command
# CMD ["/bin/bash"]

# Base image
ARG itag=latest
ARG base_name=r-4.4.0-mkl
ARG git_branch=master
FROM my_r_mkl_image:latest

ARG git_branch

# Install required system dependencies
RUN apt-get update && \
    apt-get install -y \
    cmake \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    gfortran \
    build-essential \
    software-properties-common \
    wget \
    unzip \
    zip \
    jq && \
    apt-get clean

# Install locales and configure UTF-8
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set environment variables for UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Upgrade bash to version 5 and ensure /bin/bash points to it
RUN wget http://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz && \
    tar -xzf bash-5.2.tar.gz && \
    cd bash-5.2 && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    ln -sf /usr/bin/bash /bin/bash && \
    cd .. && \
    rm -rf bash-5.2 bash-5.2.tar.gz

# Add toolchain for GCC-8
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-8 g++-8 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 60

# Create Makevars file to set C++17 compiler
RUN mkdir -p ~/.R && \
    echo "CXX17 = g++" >> ~/.R/Makevars && \
    echo "CXX17STD = -std=c++17" >> ~/.R/Makevars && \
    echo "CXX17FLAGS = -fPIC" >> ~/.R/Makevars

# Install Bioconductor packages and R libraries
RUN R -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install('Biobase')"
RUN R -e "install.packages('digest', repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install(c('SNPRelate','SeqArray', 'Rsamtools'))"
RUN R -e "install.packages(c('data.table', 'qqman', 'RColorBrewer'), repos='https://cloud.r-project.org')"

# Install PLINK
WORKDIR /opt/plink
RUN wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20230116.zip \
    && unzip plink_linux_x86_64_20230116.zip \
    && mv plink /usr/local/bin/ \
    && chmod +x /usr/local/bin/plink \
    && rm plink_linux_x86_64_20230116.zip

# Install Python and virtual environment support
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && apt-get clean

# Set up a Python virtual environment
RUN python3 -m venv /mnt/data/fan/myenv
RUN /mnt/data/fan/myenv/bin/pip install --upgrade pip

# Make Python available globally
RUN ln -sf /mnt/data/fan/myenv/bin/python3 /usr/local/bin/python && \
    ln -sf /mnt/data/fan/myenv/bin/pip /usr/local/bin/pip

# Create necessary directories for workflow
RUN mkdir -p /mnt/data/fan

# Install METAL
WORKDIR /opt/metal
RUN wget https://github.com/statgen/METAL/archive/refs/tags/2020-05-05.tar.gz -O metal.tar.gz && \
    tar -xzvf metal.tar.gz && \
    cd METAL-2020-05-05 && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make test && \
    make install && \
    mv bin/metal /usr/local/bin/ && \
    cd ../../ && \
    rm -rf METAL-2020-05-05 metal.tar.gz

# Define environment variables
ENV PATH="/usr/local/bin:/mnt/data/myenv/bin:$PATH"

# Set work directory
WORKDIR /mnt/data

# Default command
CMD ["/bin/bash"]