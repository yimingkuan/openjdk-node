FROM ubuntu:14.04

RUN apt-get update

RUN apt-get upgrade

RUN apt-get install -y software-properties-common curl git htop man wget make python g++ lib32stdc++6 lib32z1

RUN curl https://nodejs.org/dist/v6.2.0/node-v6.2.0-linux-x64.tar.gz | tar xz -C /usr/local/ --strip=1

RUN \
  echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java6-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk6-installer

  # Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-6-oracle

# install cordova
RUN npm i -g cordova

# download and extract android sdk
RUN curl http://dl.google.com/android/android-sdk_r24.2-linux.tgz | tar xz -C /usr/local/
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# update and accept licences
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | /usr/local/android-sdk-linux/tools/android update sdk --no-ui -a --filter platform-tool,build-tools-22.0.1,android-22

EXPOSE 5037

CMD adb -a -P 5037 fork-server server

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src
