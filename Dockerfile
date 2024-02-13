FROM python:3.10
RUN useradd -m jupyter
EXPOSE 8888

# Install system libraries required for geospatial packages
RUN apt-get update && apt-get install -y \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables used by the geospatial libraries
ENV GDAL_VERSION=3.0.2
ENV GEOS_VERSION=3.8.3

COPY requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN git clone https://github.com/DARPA-CRITICALMAAS/beak-ta3.git /jupyter/beak-ta3
WORKDIR /jupyter/beak-ta3
RUN pip install -r requirements.txt
RUN pip install -v .
WORKDIR /jupyter
RUN rm -r /jupyter/beak-ta3

# Install Python requirements
RUN pip install --upgrade --no-cache-dir hatch pip

# Install project requirements
COPY --chown=1000:1000 pyproject.toml README.md hatch_build.py /jupyter/

# Hack to install requirements without requiring the rest of the files
RUN pip install --no-cache-dir -e /jupyter

# Copy src code over
COPY --chown=1000:1000 . /jupyter
RUN chown -R 1000:1000 /jupyter
RUN pip install --no-cache-dir /jupyter

# Switch to non-root user. It is crucial for security reasons to not run jupyter as root user!
USER jupyter
WORKDIR /jupyter

# Service
CMD ["python", "-m", "beaker_kernel.server.main", "--ip", "0.0.0.0"]
