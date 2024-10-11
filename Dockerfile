FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
LABEL authors="sd1172@srmist.edu.in" \
      description="Docker image containing all requirements for the LncRAnalyzer pipeline"

# Install dependencies and Mambaforge
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    bzip2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -o mambaforge.sh \
    && chmod +x mambaforge.sh \
    && bash mambaforge.sh -b -p /opt/mambaforge \
    && rm mambaforge.sh

# Set environment variables for Mambaforge
ENV PATH="/opt/mambaforge/bin:${PATH}"

# Install Conda environments
COPY LncRAnalyzer.yml /tmp/
RUN mamba env update --file /tmp/LncRAnalyzer.yml && conda clean -a

COPY cpc2-cpat-slncky.yml /tmp/
RUN mamba env create --file /tmp/cpc2-cpat-slncky.yml && conda clean -a

COPY rnasamba.yml /tmp/
RUN mamba env create --file /tmp/rnasamba.yml && conda clean -a

COPY FEELnc.yml /tmp/
RUN mamba env create --file /tmp/FEELnc.yml && conda clean -a

# Install HMMER=3.1b1 from source code
WORKDIR /opt/mambaforge
RUN git clone https://github.com/slncky/slncky.git
    && ln -sf $(pwd)/slncky/* /opt/mambaforge/bin/
RUN curl -L http://eddylab.org/software/hmmer/hmmer-3.1b1.tar.gz -o hmmer-3.1b1.tar.gz \
    && tar -zxvf hmmer-3.1b1.tar.gz \
    && rm hmmer-3.1b1.tar.gz
    
WORKDIR /opt/mambaforge/hmmer-3.1b1
RUN ./configure \
    && make \
    && ln -sf $(pwd)/src/* /opt/mambaforge/bin/

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
