FROM registry.fedoraproject.org/fedora-minimal:32 AS build

RUN microdnf install unzip ncurses-compat-libs java-devel file git bzip2 patch gcc tar

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip
RUN unzip *.zip && mkdir -p sdk/cmdline-tools && mv tools/ sdk/cmdline-tools/
ENV JAVA_HOME /usr
RUN yes | sdk/cmdline-tools/tools/bin/sdkmanager "build-tools;29.0.2" "platform-tools" \
                                                 "platforms;android-29" "ndk;21.2.6472646"

FROM registry.fedoraproject.org/fedora-minimal:32
COPY --from=build /opt/sdk /opt/sdk
RUN microdnf install java-devel make git cmake ninja-build tar bzip2 patch gcc-c++ && microdnf clean all
ENV ANDROID_SDK_ROOT /opt/sdk
ENV LANG C.utf8
ENV JAVA_HOME /usr
