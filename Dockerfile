FROM registry.fedoraproject.org/fedora:45

# Install sudo (use `dnf` instead of `microdnf` on the standard fedora image)
RUN dnf -y install sudo openssh-server && \
    dnf clean all

# Create the user, add to wheel (Fedora's admin group), set up home
RUN useradd --create-home --shell /bin/bash --groups wheel railway && \
    echo "railway ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/railway && \
    chmod 0440 /etc/sudoers.d/railway

USER railway
WORKDIR /home/railway
