# ubuntu-trusty-android-rootfs

This is an updated/repacked ubu-chroot rootfs
designed for running inside AuroraOS Platform SDK
or Sailfish Platform SDK.

# AuroraOS Platform SDK

First of all, you should pull and extract `ubuntu-trusty-android-rootfs`
tar from docker repo:

```bash
docker create --name temp-ubuntu-rootfs dmfrpro/ubuntu-trusty-android-rootfs:latest
docker export temp-ubuntu-rootfs > ubuntu-trusty-android-rootfs.tar
docker rm temp-ubuntu-rootfs
```

Then you can pass tar to `install_aurora_psdk.sh` script as documented in
[AuroraOS Platform SDK Automated installation](https://developer.auroraos.ru/doc/sdk/psdk/setup_script):

```bash
wget https://sdk-repo.omprussia.ru/sdk/documents/Platform_SDK/CI/psdk_install-master.zip
unzip psdk_install-master.zip
cd psdk_install-master

./install_aurora_psdk.sh \
  --input-url https://sdk-repo.omprussia.ru/sdk/installers/5.2.0/5.2.0.45-release/AuroraPSDK/ \
  --install-dir ~/MyPSDKDir \
  --ubuchroot-tar ../ubuntu-trusty-android-rootfs.tar
```
