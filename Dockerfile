FROM python:3.10
RUN useradd -m jupyter
EXPOSE 8888
RUN mkdir -p /usr/local/share/jupyter/kernels && chmod -R 777 /usr/local/share/jupyter/kernels


# Install Julia
RUN wget --no-verbose -O julia.tar.gz "https://julialang-s3.julialang.org/bin/linux/$(uname -m|sed 's/86_//')/1.9/julia-1.9.0-linux-$(uname -m).tar.gz"
RUN tar -xzf "julia.tar.gz" && mv julia-1.9.0 /opt/julia && \
    ln -s /opt/julia/bin/julia /usr/local/bin/julia && rm "julia.tar.gz"

COPY --chown=1000:1000 environments/julia /home/jupyter/.julia/environments/v1.9

USER jupyter
WORKDIR /home/jupyter

RUN julia -e 'ENV["JUPYTER_DATA_DIR"] = "/usr/local/share/jupyter"; using Pkg; Pkg.instantiate()'
# TODO: Remove these lines and add them back into the Project.toml when branch is merged

USER root

# Install r-lang and kernel
RUN apt update && \
    apt install -y r-base r-cran-irkernel && \
    apt clean -y

WORKDIR /jupyter

# Install Python requirements
RUN pip install --no-cache-dir jupyterlab jupyterlab_server pandas matplotlib xarray numpy poetry scipy

# Install project requirements
COPY --chown=1000:1000 pyproject.toml poetry.lock /jupyter/
RUN pip install --no-cache-dir poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-dev --no-cache

# Install Mira from `hackathon` branch
RUN git clone https://github.com/indralab/mira.git /mira
WORKDIR /mira

RUN python -m pip install -e .
RUN apt update && \
    apt install -y graphviz libgraphviz-dev && \
    apt clean -y
RUN python -m pip install -e ."[ode,tests,dkg-client,sbml]"
WORKDIR /jupyter

# Kernel must be placed in a specific spot in the filesystem
COPY beaker /usr/local/share/jupyter/kernels/beaker

# Copy src code over
RUN chown 1000:1000 /jupyter
COPY --chown=1000:1000 . /jupyter


# Switch to non-root user. It is crucial for security reasons to not run jupyter as root user!
USER jupyter

CMD ["python", "service/main.py", "--ip", "0.0.0.0"]

