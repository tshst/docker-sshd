FROM centos
MAINTAINER tshuichi "takaoka.shuichi@gmail.com"

# Install package
RUN yum update  -y
RUN yum install -y openssh-server.x86_64 passwd sudo

# Create user
RUN useradd dep
RUN passwd  -f -u dep

# Set up SSH
RUN mkdir -p        /home/dep/.ssh; chown dep: /home/dep/.ssh; chmod 700 /home/dep/.ssh
ADD authorized_keys /home/dep/.ssh/authorized_keys
RUN chown dep:      /home/dep/.ssh/authorized_keys
RUN chmod 600       /home/dep/.ssh/authorized_keys

# Set up sudoers
RUN echo "dep    ALL=(ALL)       ALL" >> /etc/sudoers.d/dep

# Set up SSHD config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g'                               /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g'                                 /etc/ssh/sshd_config
RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

## Init SSHD
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop
