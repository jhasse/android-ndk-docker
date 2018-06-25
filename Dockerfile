FROM fedora:28

RUN dnf install -y unzip ncurses-compat-libs java-devel && dnf clean all

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip *.zip && rm *.zip && mkdir sdk && mv tools/ sdk/
ENV ANDROID_HOME /opt/sdk
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3" "platforms;android-25"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

RUN curl --silent -O https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip && \
    unzip *.zip && rm *.zip
ENV ANDROID_NDK_HOME /opt/android-ndk-r17b
