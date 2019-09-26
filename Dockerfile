#FROM imiell/bad-dockerfile
FROM registry.access.redhat.com/rhel7:7.5-409               
#FROM ubuntu:latest
#FROM python:3.7-alpine
# The python:3.7-alpine is the 'good' image :)

LABEL maintainer="howie_howerton@trendmicro.com"

# Enable or Disable the following RUN statements according to the FROM statement used above.
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py    # enable/disable with rhel7
RUN python get-pip.py                                          # enable/disable with rhel7
#RUN apt-get update -y                                         # enable/disable with ubuntu:latest
#RUN apt upgrade -y                                            # enable/disable with ubuntu:latest
#RUN apt-get install -y python-pip python-dev build-essential  # enable/disable with ubuntu:latest

# Adding the Flask application code and dependencies
ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt

# CONTENT OPTIONS - Enable or Disable the following RUN statements as desired
# EICAR - Malware test file
#RUN echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar.txt

# AWS credentials file
RUN mkdir -p ~/.aws
RUN echo '[default]' >> ~/.aws/credentials
RUN echo 'aws_access_key_id = AKIA3AMSFYUPYXABC123' >> ~/.aws/credentials
RUN echo 'aws_secret_access_key = Ucck2xPPNKx84W+OWhLYtI7LpNj0kwz7MlABC123' >> ~/.aws/credentials

# Run the Flask application
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
