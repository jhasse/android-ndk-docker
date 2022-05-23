FROM registry.fedoraproject.org/fedora-minimal:36 AS build

RUN microdnf install -y unzip ncurses-compat-libs java-11-openjdk-devel file git bzip2 patch gcc tar

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
RUN unzip *.zip && mkdir -p sdk/cmdline-tools/ && mv cmdline-tools/ sdk/cmdline-tools/latest
ENV JAVA_HOME /usr
RUN yes | sdk/cmdline-tools/latest/bin/sdkmanager "build-tools;30.0.3" "platforms;android-30" \
                                                  "ndk;24.0.8215888"

FROM registry.fedoraproject.org/fedora-minimal:36
COPY --from=build /opt/sdk /opt/sdk
RUN microdnf install -y java-11-openjdk-devel make git cmake ninja-build tar bzip2 patch gcc-c++ unzip && microdnf clean all
ENV ANDROID_SDK_ROOT /opt/sdk
ENV LANG C.utf8
ENV JAVA_HOME /usr
