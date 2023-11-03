# Use an official Jenkins image as the base
FROM jenkins/jenkins:jdk11



USER root
RUN chmod -R 755 /var
RUN chown -R jenkins:jenkins /var/jenkins_home
USER jenkins

# Example: Set environment variables to customize Jenkins
ENV JENKINS_HOME /var/jenkins_home
