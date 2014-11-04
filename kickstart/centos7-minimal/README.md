#### Create a bootable CentOS 7 minimal image with custom kickstart configuration

1. Copy the contents of the ISO to a directory
```
cd centos7-minimal
cp /data/staging/CentOS-7.0-1406-x86_64-Minimal.iso .
mkdir in out
sudo mount -o loop CentOS-7.0-1406-x86_64-Minimal.iso in
cp -rT in/ out/
```

2. Modify the contents of the original ISO to load the kickstart configuration

Change to the `out` directory
```
cd out
```
- Copy the `ks.cfg` file to the `out` directory
- Add `inst.ks=cdrom:/dev/cdrom:/ks.cfg` to the **append** entry for the `label linux` entry. 
- Remove the `quiet` option.
- Update the menu label 
- Save the file

3. Create the new ISO image

```
chmod 664 isolinux/isolinux.bin
mkisofs -o ../CentOS-7.0-1406-x86_64-Minimal.2014-10-04-1.iso -b isolinux.bin -c boot.cat -no-emul-boot \
  -V 'CentOS 7 x86_64' \
  -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
```
4. Burn the image to media and test

#### References

[http://smorgasbork.com/component/content/article/35-linux/151-building-a-custom-centos-7-kickstart-disc-part-1]
