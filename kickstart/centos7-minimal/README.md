#### Create a bootable CentOS 7 minimal image with custom kickstart configuration

1. Copy the contents of the ISO to a directory
```
mkdir in out
sudo mount -o loop CentOS-7.0-1406-x86_64-Minimal.iso in
cp -rT in/ out/
```

2. Modify the contents of the original ISO to load the kickstart configuration

- Add ```inst.ks=cdrom:/dev/cdrom:/ks/ks.cfg```to the **append** entry for the ```label linux`` entry. 
- Remove the ```quiet``` option.
- Update the menu label 
- Save the file

3. Create the new ISO image

```
sudo mkisofs -U -A "CentOS-7-C1" -V "CentOS-7-C1" -volset "CentOS-7-C1" -J -joliet-long \
 -r -v -T -o ../CentOS-7-C1.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot .
```

#### References

[http://smorgasbork.com/component/content/article/35-linux/151-building-a-custom-centos-7-kickstart-disc-part-1]
