FROM registry.fedoraproject.org/fedora-minimal:32 AS build

RUN microdnf install unzip ncurses-compat-libs java-devel file git bzip2 patch gcc tar

WORKDIR /opt

RUN curl --silent -O https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip
RUN unzip *.zip && mkdir -p sdk/cmdline-tools/ && mv cmdline-tools/ sdk/cmdline-tools/latest
ENV JAVA_HOME /usr
RUN yes | sdk/cmdline-tools/latest/bin/sdkmanager "build-tools;29.0.2" "platforms;android-29" \
                                                  "ndk;22.1.7171670"

FROM registry.fedoraproject.org/fedora-minimal:32
COPY --from=build /opt/sdk /opt/sdk
RUN microdnf install java-devel make git cmake ninja-build tar bzip2 patch gcc-c++ unzip && microdnf clean all
ENV ANDROID_SDK_ROOT /opt/sdk
ENV LANG C.utf8
ENV JAVA_HOME /usr
