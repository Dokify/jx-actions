FROM ghcr.io/jenkins-x/jx-boot:3.10.115 as jx-builder
FROM google/cloud-sdk:398.0.0-slim

COPY --from=jx-builder /usr/bin/jx /usr/bin/jx

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    apt update && apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin && rm -rf /var/lib/apt/lists/*

ENV GOOGLE_APPLICATION_CREDENTIALS /root/.config/gcloud/application_default_credentials.json

USER root

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
