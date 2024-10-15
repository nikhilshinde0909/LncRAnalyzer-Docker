FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
LABEL authors="sd1172@srmist.edu.in" \
      description="Docker image containing all requirements for the LncRAnalyzer pipeline"

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    bash \
    curl \
    wget \
    git \
    bzip2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* 

# Install Miniforge
RUN curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o miniforge.sh \
    && chmod +x miniforge.sh \
    && bash miniforge.sh -b -p /opt/miniforge \
    && rm miniforge.sh

# Set environment variables for miniforge
ENV PATH="/opt/miniforge/bin:${PATH}"

# Install Conda environments
COPY LncRAnalyzer.yml /tmp/
RUN mamba env update --file /tmp/LncRAnalyzer.yml && conda clean -a

COPY cpc2-cpat-slncky.yml /tmp/
RUN mamba env create --file /tmp/cpc2-cpat-slncky.yml && conda clean -a

COPY rnasamba.yml /tmp/
RUN mamba env create --file /tmp/rnasamba.yml && conda clean -a

COPY FEELnc.yml /tmp/
RUN mamba env create --file /tmp/FEELnc.yml && conda clean -a

# Install Slncky from source code
WORKDIR /opt/miniforge
RUN git clone https://github.com/slncky/slncky.git \
    && ln -sf $(pwd)/slncky/* /opt/miniforge/envs/cpc2-cpat-slncky/bin/

# Install HMMER=3.1b1 from source code    
RUN curl -L http://eddylab.org/software/hmmer/hmmer-3.1b1.tar.gz -o hmmer-3.1b1.tar.gz \
    && tar -zxvf hmmer-3.1b1.tar.gz \
    && rm hmmer-3.1b1.tar.gz
    
WORKDIR /opt/miniforge/hmmer-3.1b1
RUN ./configure \
    && make \
    && ln -sf $(pwd)/src/* /opt/miniforge/bin/

# Create a directory for LncRAnalyzer
WORKDIR /pipeline
RUN mkdir LncRAnalyzer

# Copy LncRAnalyzer
COPY . /pipeline/LncRAnalyzer

# Copy and run the script to add paths for tools
COPY add_paths_for_tools.sh /tmp/
RUN chmod +x /tmp/add_paths_for_tools.sh && bash /tmp/add_paths_for_tools.sh > $(pwd)/LncRAnalyzer/tools.groovy

# Default command to start a bash shell
CMD ["bash"]
