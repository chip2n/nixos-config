Boot into NixOS live USB and prepare for encryption by wiping the HDD:

    # shred -v -n 3 /dev/sda

Create GPT partitions:

    # gdisk /dev/sda
    ...
    Command: n
    Partition number: 
    First sector: 
    Last sector: +250MB
    Nex code or GUID: ef00

    Command: n
    Partition number:
    First sector:
    Last sector:
    Hex code or GUID: 8e00

    Command: w

Encrypt using cryptsetup:

    # cryptsetup luksFormat /dev/sda2
    # cryptsetup luksOpen /dev/sda2 enc_pv
    
    # pvcreate /dev/mapper/enc_pv
    # vgcreate vg /dev/mapper/enc_pv
    # lvcreate -L 50G -n root_vol vg
    # lvcreate -L 16G -n swap_vol vg
    # lvcreate -L 50G -n home_vol vg

    # mkfs.ext4 -L root_vol /dev/vg/root_vol
    # mkfs.ext4 -L home_vol /dev/vg/home_vol
    # mkswap -L swap_vol /dev/vg/swap_vol
    # mkfs.vfat -n boot_vol /dev/sda1      # works??

    # mount /dev/vg/root_vol /mnt
    # mkdir /mnt/boot
    # mount /dev/sda1 /mnt/boot

    # swapon /dev/vg/swap_vol
    # nixos-generate-config --root /mnt

Add the following to /mnt/etc/nixos/configuration.nix:

    boot.initrd.luks.devices = [
      {
        device = "/dev/sda2";
        name = "enc_pv";
        preLVM = true;
      }
    ];

Install NixOS:

    # nixos-install

After installation, set passwords of created users:

    # passwd chip

Enable WPA WiFi by adding credentials to /etc/wpa_supplicant.conf

    network={
      ssid="Hide Your Kids, Hide Your Wi-Fi"
      psk="*****"
    }

TODO: Custom live USB with git preinstalled (and other scripts)

NOTE: If dualbooting, install Windows last and set EFI boot loader to Linux in "BIOS". Doing it the other way around seem to remove Windows boot loader.
