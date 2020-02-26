FROM registry.fedoraproject.org/fedora-minimal:31

ENV LANG en_US.UTF-8
RUN microdnf install unzip ncurses-compat-libs java-devel file git make bzip2 patch gcc tar && \
    microdnf clean all

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip *.zip && rm *.zip && mkdir sdk && mv tools/ sdk/
ENV ANDROID_HOME /opt/sdk
ENV JAVA_HOME /usr
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" "platform-tools" \
                                             "cmake;3.10.2.4988404" "platforms;android-29" \
                                             "ndk;21.0.6113669"

RUN curl --silent -O -L https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2 && \
    tar -xf *.tar.bz2 'boost_1_*_0/boost' && \
    mv boost_1_*_0/boost/ $ANDROID_HOME/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/ && \
    rm *.tar.bz2 && rm -r boost*/
