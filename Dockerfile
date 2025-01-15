FROM us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.20.0

# Check out repository files.
RUN cd /usr/local && \
    git clone https://github.com/UW-GAC/primed-reports.git

# This file does not have versions - we don't want to overwrite existing versions in the base image.
RUN pip install -r /usr/local/primed-reports/requirements.txt

# Install additional R packages
RUN R -e "install.packages(c('kableExtra', 'rmdformats'))"

CMD /bin/sh
