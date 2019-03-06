FROM python:3.7-alpine3.7

ARG https_proxy_url

ENV HTTP_PROXY "$https_proxy_url"
ENV HTTPS_PROXY "$https_proxy_url"

ENV WORKING_DIRECTORY /opt/stix
RUN mkdir -p $WORKING_DIRECTORY
WORKDIR $WORKING_DIRECTORY

COPY . $WORKING_DIRECTORY

RUN pip3 install pipenv --default-timeout=100
# installing dev to do unit tests from docker
RUN pipenv install --dev --system

# Run as non-root
RUN addgroup -g 30000 -S appuser && \
adduser -u 30000 -S appuser -G appuser

RUN chown -R 30000:30000 $WORKING_DIRECTORY

EXPOSE 5000

USER 30000
