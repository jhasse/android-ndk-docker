FROM fedora:28

RUN dnf install -y unzip ncurses-compat-libs java-devel file git make bzip2 patch && \
    dnf clean all

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip *.zip && rm *.zip && mkdir sdk && mv tools/ sdk/
ENV ANDROID_HOME /opt/sdk
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3" "platform-tools" \
                                             "cmake;3.6.4111459" "platforms;android-28" "ndk-bundle"

RUN curl --silent -O -L https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2 && \
    tar -xf *.tar.bz2 boost_1_*_0/boost && \
    mv boost_1_*_0/boost/ $ANDROID_HOME/ndk-bundle/sysroot/usr/include/ && rm *.tar.bz2 && \
    rm -r boost*/
