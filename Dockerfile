FROM alpine:3.11


ENV AZURE_CLI_VERSION 2.0.81
ENV TERRAFORM_VERSION 0.12.28
ENV KUBE_VERSION v1.15.9
ENV HELM_VERSION v3.0.3
ENV TFLINT_VERSION v0.21.0

#install nodejs
RUN apk add --update --no-cache npm nodejs

# Install needed packages and Azure CLI
RUN apk add --update --no-cache \
	postgresql-client \
    python3 \
	htop \
	util-linux pciutils usbutils coreutils binutils findutils grep \
	udisks2 udisks2-doc \
    curl \ 
	openssh openssh-keygen openssh-client \
    git \
    jq \
    gettext && \
    apk add --virtual .build-deps \
    gcc \
    libffi-dev \
    musl-dev \
    openssl-dev \
    make \
	nmap \
    python3-dev \
    linux-headers && \
	pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir azure-cli==$AZURE_CLI_VERSION  && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*


RUN apk add --update --no-cache bind bind-tools

# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip | unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin - && \
    chmod +x /usr/local/bin/terraform

# Install kubectl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install Helm
RUN curl https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm
	
#install checkov for tf static code testing
RUN pip3 --no-cache-dir install checkov

#install tflint for tf static code testing
RUN curl -L "https://github.com/terraform-linters/tflint/releases/download/$TFLINT_VERSION/tflint_linux_amd64.zip" -o /tmp/tflint.zip \
&&  unzip /tmp/tflint.zip \
&& rm /tmp/tflint.zip \
&& install ./tflint /usr/local/bin \
&& tflint -v

WORKDIR /home
