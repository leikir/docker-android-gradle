FROM leikir/ruby-bundler-node-yarn:ruby-2.3.6-node-6.9.4-stretch

MAINTAINER Leikir Web <web@leikir.io>

ENV LC_ALL "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LANG "en_US.UTF-8"

ENV VERSION_SDK_TOOLS "3859397"
ENV VERSION_BUILD_TOOLS "26.0.2"
ENV VERSION_TARGET_SDK "26"
ENV VERSION_GRADLE "4.1"

ENV ANDROID_HOME /sdk

ENV HOME /root

ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR $INSTALL_PATH

RUN apt-get update
RUN apt-get -y install --no-install-recommends \
  build-essential \
  curl \
  file \
  git \
  openjdk-8-jdk \
  ssh \
  unzip \
  zip

RUN wget \
  https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip \
  -O /tools.zip \
  && unzip /tools.zip -d ${ANDROID_HOME} \
  && rm /tools.zip

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN mkdir -p $HOME/.android && touch $HOME/.android/repositories.cfg
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "tools" "platforms;android-${VERSION_TARGET_SDK}" "build-tools;${VERSION_BUILD_TOOLS}"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget \
  https://services.gradle.org/distributions/gradle-${VERSION_GRADLE}-bin.zip \
  -O /gradle.zip \
  && unzip /gradle.zip -d ${ANDROID_HOME} \
  && rm /gradle.zip

ENV PATH "$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${VERSION_BUILD_TOOLS}:${ANDROID_HOME}/gradle-${VERSION_GRADLE}/bin"
