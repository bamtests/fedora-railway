FROM registry.fedoraproject.org/fedora:45

RUN dnf -y install curl \
    && CODE_SERVER_VERSION=$(curl -fsSL https://api.github.com/repos/coder/code-server/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]*') \
    && curl -fOL https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-amd64.rpm \
    && dnf install -y code-server-${CODE_SERVER_VERSION}-amd64.rpm \
    && rm code-server-${CODE_SERVER_VERSION}-amd64.rpm \
    && dnf clean all

# User with passwordless sudo
RUN useradd --create-home --shell /bin/bash --groups wheel railway && \
    printf 'railway ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/railway && \
    chmod 0440 /etc/sudoers.d/railway

USER railway
WORKDIR /home/railway

RUN echo 'export PS1="\u@\${RAILWAY_SERVICE_NAME:-\$HOSTNAME} \w \$ "' \
    > /home/railway/.bashrc

# Railway sets PORT; default to 8080 for local podman testing
ENV PORT=8080

CMD ["sh", "-c", "exec code-server --bind-addr 0.0.0.0:${PORT} --auth password --disable-telemetry /home/railway"]
