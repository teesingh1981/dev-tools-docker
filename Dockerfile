FROM mcr.microsoft.com/azure-cli:2.0.77

# --- Arguments ---
ARG TERRAFORM_VERSION="0.12.27"

# --- Re-usable environment variables ---
ENV TMP_DIR="/tmp"
ENV TERRAFORM_DIR="/opt/terraform"

RUN apk update && apk --no-cache add bash py-pip && apk --no-cache add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make curl openssl wget unzip
RUN apk add sed attr dialog dialog-doc bash bash-doc bash-completion grep grep-doc
RUN apk add util-linux util-linux-doc pciutils usbutils binutils findutils readline
RUN apk add man man-pages lsof lsof-doc less less-doc nano nano-doc  curl-doc busybox-extras bind-tools 



# --- install kubectl ---
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$k8sversion/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl



# --- Install Terraform ---
WORKDIR ${TMP_DIR}
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform.zip
RUN mkdir ${TERRAFORM_DIR}
RUN mv terraform ${TERRAFORM_DIR}/.
RUN ln -s ${TERRAFORM_DIR}/terraform /usr/local/bin/terraform
RUN rm -rf ${TMP_DIR}/*
WORKDIR /

# Ready for run
CMD sh