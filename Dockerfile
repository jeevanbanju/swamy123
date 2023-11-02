# Use an official Jenkins image as the base
FROM jenkins/jenkins:jdk11

# Install any additional system packages or dependencies
USER root
RUN apt-get update && apt-get install -y git

# Switch back to the Jenkins user
USER jenkins

# Copy plugins.txt into the image
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install Jenkins plugins using the "jenkins-plugin-cli"
# RUN jenkins-plugin-cli --plugins /usr/share/jenkins/ref/plugins.txt

# Copy custom configuration files to the Jenkins home directory (uncomment these lines if needed)
# COPY custom-config.xml /var/jenkins_home
# COPY custom-script.groovy /var/jenkins_home/init.groovy.d/

RUN RUN chmod -R  755 /var/jenkins_home

# Example: Set environment variables to customize Jenkins
ENV JENKINS_HOME /var/jenkins_home


