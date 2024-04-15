FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl netcat jq openssl ca-certificates
RUN curl -LO https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl --output-dir /usr/local/bin/ && chmod +x /usr/local/bin/kubectl

COPY scripts /home/caldera

WORKDIR /home/caldera

ENTRYPOINT ["/home/caldera/run-agent.sh"]
