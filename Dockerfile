# Use an official Jenkins image as the base
FROM jenkins/jenkins:lts

# Install any additional system packages or dependencies
USER root
RUN apt-get update && apt-get install -y \
    
USER jenkins

# Install Jenkins plugins using the "install-plugins.sh" script
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy custom configuration files to the Jenkins home directory
# COPY custom-config.xml /var/jenkins_home

# Add any additional custom scripts or files as needed
# COPY custom-script.groovy /var/jenkins_home/init.groovy.d/

# Example: Set environment variables to customize Jenkins
ENV JENKINS_HOME /var/jenkins_ho
