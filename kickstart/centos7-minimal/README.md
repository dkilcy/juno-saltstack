#### Create a bootable CentOS 7 minimal image with custom kickstart configuration

```
mkdir in out
sudo mount -o loop CentOS-7.0-1406-x86_64-Minimal.iso in
cp -rT in/ out/

cd out


sudo mkisofs -U -A "CentOS-7-C1" -V "CentOS-7-C1" -volset "CentOS-7-C1" -J -joliet-long \
 -r -v -T -o ../CentOS-7-C1.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot .
```
