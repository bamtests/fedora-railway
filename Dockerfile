FROM registry.fedoraproject.org/fedora:45

RUN dnf -y install curl && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    dnf clean all

# User with passwordless sudo
RUN useradd --create-home --shell /bin/bash --groups wheel railway && \
    printf 'railway ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/railway && \
    chmod 0440 /etc/sudoers.d/railway

USER railway
WORKDIR /home/railway

# Railway sets PORT; default to 8080 for local podman testing
ENV PORT=8080

CMD ["sh", "-c", "exec code-server --bind-addr 0.0.0.0:${PORT} --auth password --disable-telemetry /home/railway"]
