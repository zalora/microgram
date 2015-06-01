/*

  WARNING/NOTE: whenever you want to add an option here you need to
  either

  * mark it as an optional one with `?` suffix,
  * or make sure it works for all the versions in nixpkgs,
  * or check for which kernel versions it will work (using kernel
    changelog, google or whatever) and mark it with `versionOlder` or
    `versionAtLeast`.

  Then do test your change by building all the kernels (or at least
  their configs) in nixpkgs or else you will guarantee lots and lots
  of pain to users trying to switch to an older kernel because of some
  hardware problems with a new one.

*/

{ stdenv, version, kernelPlatform, extraConfig, features }:

with stdenv.lib;

''
  # Debugging.
  DEBUG_KERNEL y
  TIMER_STATS y
  BACKTRACE_SELF_TEST n
  CPU_NOTIFIER_ERROR_INJECT? n
  DEBUG_DEVRES n
  DEBUG_NX_TEST n
  DEBUG_STACK_USAGE n
  ${optionalString (!(features.grsecurity or false)) ''
    DEBUG_STACKOVERFLOW n
  ''}
  RCU_TORTURE_TEST n
  SCHEDSTATS n
  DETECT_HUNG_TASK y

  # Power management.
  ${optionalString (versionOlder version "3.19") ''
    PM_RUNTIME y
  ''}
  PM_ADVANCED_DEBUG y
  ${optionalString (versionAtLeast version "3.10") ''
    X86_INTEL_PSTATE y
  ''}
  INTEL_IDLE y
  CPU_FREQ_DEFAULT_GOV_PERFORMANCE y
  ${optionalString (versionOlder version "3.10") ''
    USB_SUSPEND y
  ''}

  # Support drivers that need external firmware.
  STANDALONE n

  # Make /proc/config.gz available.
  IKCONFIG_PROC y

  # Optimize with -O2, not -Os.
  CC_OPTIMIZE_FOR_SIZE n

  # Enable the kernel's built-in memory tester.
  MEMTEST y

  # Include the CFQ I/O scheduler in the kernel, rather than as a
  # module, so that the initrd gets a good I/O scheduler.
  IOSCHED_CFQ y
  BLK_CGROUP y # required by CFQ

  # Enable NUMA.
  NUMA? y

  # Disable some expensive (?) features.
  PM_TRACE_RTC n

  # Enable various subsystems.
  ACCESSIBILITY n # Accessibility support
  AUXDISPLAY n # Auxiliary Display support
  HIPPI y
  ${optionalString (versionOlder version "3.2") ''
    NET_POCKET y # enable pocket and portable adapters
  ''}
  #SCSI_LOWLEVEL y # enable lots of SCSI devices
  #SCSI_LOWLEVEL_PCMCIA y
  #SCSI_SAS_ATA y  # added to enable detection of hard drive
  SPI y # needed for many devices
  SPI_MASTER y

  # Networking options.
  IP_PNP n
  ${optionalString (versionOlder version "3.13") ''
    IPV6_PRIVACY y
  ''}
  NETFILTER_ADVANCED y
  IP_VS_PROTO_TCP y
  IP_VS_PROTO_UDP y
  IP_VS_PROTO_ESP y
  IP_VS_PROTO_AH y
  IP_DCCP_CCID3 n # experimental
  CLS_U32_PERF y
  CLS_U32_MARK y
  ${optionalString (stdenv.system == "x86_64-linux") ''
    BPF_JIT y
  ''}

  # Filesystem options - in particular, enable extended attributes and
  # ACLs for all filesystems that support them.
  FANOTIFY y
  EXT2_FS_XATTR y
  EXT2_FS_POSIX_ACL y
  EXT2_FS_SECURITY y
  ${optionalString (versionOlder version "4.0") ''
    EXT2_FS_XIP y # Ext2 execute in place support
  ''}
  EXT3_FS_POSIX_ACL y
  EXT3_FS_SECURITY y
  EXT4_FS_POSIX_ACL y
  EXT4_FS_SECURITY y
  REISERFS_FS_XATTR? y
  REISERFS_FS_POSIX_ACL? y
  REISERFS_FS_SECURITY? y
  JFS_POSIX_ACL? y
  JFS_SECURITY? y
  XFS_QUOTA? y
  XFS_POSIX_ACL? y
  XFS_RT? y # XFS Realtime subvolume support
  OCFS2_DEBUG_MASKLOG? n
  #BTRFS_FS_POSIX_ACL? y
  #UBIFS_FS_ADVANCED_COMPR? y
  ${optionalString (versionAtLeast version "3.6") ''
    NFS_SWAP y
  ''}
  ${optionalString (versionAtLeast version "3.11") ''
    NFS_V4_1 y  # NFSv4.1 client support
    NFS_V4_2 y
  ''}
  NFSD_V2_ACL y
  NFSD_V3 y
  NFSD_V3_ACL y
  NFSD_V4 y
  NFS_FSCACHE y
  ${optionalString (versionAtLeast version "3.13") ''
    SQUASHFS_FILE_DIRECT y
    SQUASHFS_DECOMP_MULTI_PERCPU y
  ''}
  SQUASHFS_XATTR y
  SQUASHFS_ZLIB y
  SQUASHFS_LZO y
  SQUASHFS_XZ y
  ${optionalString (versionAtLeast version "3.19") ''
    SQUASHFS_LZ4 y
  ''}

  # Security related features.
  STRICT_DEVMEM y # Filter access to /dev/mem
  SECURITY_SELINUX_BOOTPARAM_VALUE 0 # Disable SELinux by default
  DEVKMEM? n # Disable /dev/kmem
  ${if versionOlder version "3.14" then ''
    CC_STACKPROTECTOR? y # Detect buffer overflows on the stack
  '' else ''
    CC_STACKPROTECTOR_REGULAR? y
  ''}
  ${optionalString (versionAtLeast version "3.12") ''
    USER_NS y # Support for user namespaces
  ''}

  # AppArmor support
  SECURITY_APPARMOR y
  DEFAULT_SECURITY_APPARMOR y

  # Microcode loading support
  MICROCODE y
  MICROCODE_INTEL y
  MICROCODE_AMD y
  ${optionalString (versionAtLeast version "3.11") ''
    MICROCODE_EARLY y
    MICROCODE_INTEL_EARLY y
    MICROCODE_AMD_EARLY y
  ''}

  # Misc. options.
  8139TOO_8129 y
  8139TOO_PIO n # PIO is slower
  ${optionalString (versionAtLeast version "3.3" && versionOlder version "3.13") ''
    AUDIT_LOGINUID_IMMUTABLE y
  ''}
  BSD_PROCESS_ACCT_V3 y
  CRASH_DUMP? n
  ${optionalString (versionOlder version "3.1") ''
    DMAR? n # experimental
  ''}
  ${optionalString (versionAtLeast version "3.3") ''
    EFI_STUB y # EFI bootloader in the bzImage itself
  ''}
  FHANDLE y # used by systemd
  LDM_PARTITION y # Windows Logical Disk Manager (Dynamic Disk) support

  MODVERSIONS y
  MTRR_SANITIZER y
  NET_FC y # Fibre Channel driver support
  PPP_MULTILINK y # PPP multilink support
  PPP_FILTER y
  SCSI_LOGGING y # SCSI logging facility
  SERIAL_8250 y # 8250/16550 and compatible serial support
  SLIP_COMPRESSED y # CSLIP compressed headers
  SLIP_SMART y
  ${optionalString (versionAtLeast version "3.15") ''
    UEVENT_HELPER n
  ''}
  ${optionalString (versionOlder version "3.15") ''
    USB_DEBUG? n
  ''}
  #USB_EHCI_ROOT_HUB_TT y # Root Hub Transaction Translators
  #USB_EHCI_TT_NEWSCHED y # Improved transaction translator scheduling
  X86_CHECK_BIOS_CORRUPTION y
  X86_MCE y

  # Linux containers.
  RT_GROUP_SCHED? y
  CGROUP_DEVICE? y
  ${if versionAtLeast version "3.6" then ''
    MEMCG y
    MEMCG_SWAP y
  '' else ''
    CGROUP_MEM_RES_CTLR y
    CGROUP_MEM_RES_CTLR_SWAP y
  ''}
  DEVPTS_MULTIPLE_INSTANCES y
  BLK_DEV_THROTTLING y
  CFQ_GROUP_IOSCHED y

  STAGING y

  # PROC_EVENTS requires that the netlink connector is not built
  # as a module.  This is required by libcgroup's cgrulesengd.
  CONNECTOR y
  PROC_EVENTS y

  # Tracing.
  FTRACE y
  KPROBES y
  FUNCTION_TRACER y
  FTRACE_SYSCALLS y
  SCHED_TRACER y
  STACK_TRACER y
  ${optionalString (versionAtLeast version "3.10") ''
    UPROBE_EVENT y
  ''}
  FUNCTION_PROFILER y
  RING_BUFFER_BENCHMARK n

  # Devtmpfs support.
  DEVTMPFS y

  # Easier debugging of NFS issues.
  ${optionalString (versionAtLeast version "3.4") ''
    SUNRPC_DEBUG y
  ''}

  # Virtualisation.
  PARAVIRT? y
  ${if versionAtLeast version "3.10" then ''
    HYPERVISOR_GUEST? y
  '' else ''
    PARAVIRT_GUEST? y
  ''}
  KVM_GUEST? y
  ${optionalString (versionOlder version "3.7") ''
    KVM_CLOCK? y
  ''}
  XEN? y
  XEN_DOM0? y
  ${optionalString ((versionAtLeast version "3.18") && (features.xen_dom0 or false))  ''
    PCI_XEN? y
    HVC_XEN? y
    HVC_XEN_FRONTEND? y
    XEN_SYS_HYPERVISOR? y
    SWIOTLB_XEN? y
    XEN_BACKEND? y
    XEN_BALLOON? y
    XEN_BALLOON_MEMORY_HOTPLUG? y
    XEN_EFI? y
    XEN_HAVE_PVMMU? y
    XEN_MCE_LOG? y
    XEN_PVH? y
    XEN_PVHVM? y
    XEN_SAVE_RESTORE? y
    XEN_SCRUB_PAGES? y
    XEN_SELFBALLOONING? y
    XEN_STUB? y
    XEN_TMEM? y
  ''}
  KSM y
  ${optionalString (!stdenv.is64bit) ''
    HIGHMEM64G? y # We need 64 GB (PAE) support for Xen guest support.
  ''}
  ${optionalString (versionAtLeast version "3.9" && stdenv.is64bit) ''
    VFIO_PCI_VGA y
  ''}
  VIRT_DRIVERS y

  # Our initrd init uses shebang scripts, so can't be modular.
  ${optionalString (versionAtLeast version "3.10") ''
    BINFMT_SCRIPT y
  ''}

  # 9P is used by NixOS Tests (via qemu support).
  # 9P_FS y
  9P_FSCACHE y
  9P_FS_POSIX_ACL y
  # NET_9P y
  # NET_9P_VIRTIO y

  # Enable transparent support for huge pages.
  TRANSPARENT_HUGEPAGE? y
  TRANSPARENT_HUGEPAGE_ALWAYS? n
  TRANSPARENT_HUGEPAGE_MADVISE? y

  # zram support (e.g for in-memory compressed swap).
  ${optionalString (versionAtLeast version "3.4") ''
    ZSMALLOC y
  ''}
  ZRAM m

  ${optionalString (versionAtLeast version "3.17") "NFC? n"}

  # Enable firmware loading via udev. Only needed for non-declarative
  # firmware in /root/test-firmware.
  ${optionalString (versionAtLeast version "3.17") ''
    FW_LOADER_USER_HELPER_FALLBACK y
  ''}

  # Disable lots of unused subsystems:

  DRM n
  SOUND n
  #SND n
  FB n
  #I2C n
  #PPS n
  HWMON y
  THERMAL y
  #THERMAL_HWMON y # Hardware monitoring support
  BT n
  ATM n
  CAN n
  MTD n
  #MTD_COMPLEX_MAPPINGS y # needed for many devices
  I2O n
  ARCNET n
  IRDA n
  AX25 n
  AF_RXRPC n
  RFKILL n
  CAIF n
  PARPORT n
  IDE n # deprecated
  AFS_FS n

  INPUT_JOYSTICK n
  INPUT_KEYBOARD y
  INPUT_MISC n
  INPUT_MOUSE n
  INPUT_MOUSEDEV n
  INPUT_TABLET n
  INPUT_TOUCHSCREEN n

  AGP n
  TCG_TPM n
  DRM n
  PMBUS n
  MEDIA_SUPPORT n
  HID n
  I2C_HID n
  USB_HID n
  WAN n
  IEEE802154_DRIVERS n
  PCCARD n
  #CARDBUS n
  RAPIDIO n
  HOTPLUG_PCI_SHPC n
  IIO n
  ASUS_LAPTOP n
  DELL_LAPTOP n
  INFINIBAND n
  FIREWIRE n
  WLAN n
  WIRELESS n
  #POWER_SUPPLY n
  ACPI_AC n
  ACPI_BATTERY n
  ACPI_SBS n
  LEDS_BLINKM n
  WIMAX n
  USB_NET_DRIVERS n
  COMEDI n

  HOTPLUG_PCI_ACPI y


  # initially obtained from:
  # exclude.amd64-virtual from ubuntu distribution
  # cat exclude.amd64-virtual | sed 's/\(.*\).ko$/CONFIG.*\1/' | xargs -n1 -I% grep -R % linux-3.19.7 | sed 's/.*CONFIG_\(.*\))/\1? n/' | sort -u

#  IPMI_DEVICE_INTERFACE? n
  IPMI_HANDLER? n
#  IPMI_POWEROFF? n
#  IPMI_SI? n
#  IPMI_WATCHDOG? n
  PATA_ALI? n
  PATA_AMD? n
  PATA_ARTOP? n
  PATA_ATIIXP? n
  PATA_ATP867X? n
  PATA_CMD640_PCI? n
  PATA_CMD64X? n
  PATA_CYPRESS? n
  PATA_EFAR? n
  PATA_HPT366? n
  PATA_HPT37X? n
  PATA_HPT3X2N? n
  PATA_HPT3X3? n
  PATA_IT8213? n
  PATA_IT821X? n
  PATA_JMICRON? n
  PATA_LEGACY? n
  PATA_MARVELL? n
  PATA_MPIIX? n
  PATA_NETCELL? n
  PATA_NINJA32? n
  PATA_NS87410? n
  PATA_NS87415? n
  PATA_OLDPIIX? n
  PATA_OPTI? n
  PATA_OPTIDMA? n
  PATA_PDC2027X? n
  PATA_PDC_OLD? n
  PATA_RADISYS? n
  PATA_RDC? n
  PATA_RZ1000? n
  PATA_SCH? n
  PATA_SERVERWORKS? n
  PATA_SIL680? n
  PATA_TRIFLEX? n
  PATA_VIA? n
  PATA_WINBOND? n
  PPPOE? n
  PPPOL2TP? n
  PPP_ASYNC? n
  PPP_DEFLATE? n
  PPP_MPPE? n
  PPP_SYNC_TTY? n
  PPTP? n
  SATA_ACARD_AHCI? n
  SATA_INIC162X? n
  SATA_MV? n
  SATA_NV? n
  SATA_PROMISE? n
  SATA_QSTOR? n
  SATA_SIL24? n
  SATA_SIL? n
  SATA_SIS? n
  SATA_SVW? n
  SATA_SX4? n
  SATA_ULI? n
  SATA_VIA? n
  SATA_VITESSE? n
  SPEAKUP? n
  USB_EHCI_HCD? n
  #USB_EHCI_TEGRA? n
  USB_HSO? n
  USB_ISP116X_HCD? n
  USB_ISP1760_HCD? n
  USB_KAWETH? n
  USB_KBD? n
  USB_MOUSE? n
  USB_NET_AX8817X? n
  USB_NET_CDCETHER? n
  USB_NET_CDC_EEM? n
  USB_NET_CDC_SUBSET? n
  USB_NET_DM9601? n
  USB_NET_GL620A? n
  USB_NET_INT51X1? n
  USB_NET_MCS7830? n
  USB_NET_NET1080? n
  USB_NET_PLUSB? n
  USB_NET_RNDIS_HOST? n
  USB_NET_SMSC75XX? n
  USB_NET_SMSC95XX? n
  USB_NET_ZAURUS? n
  USB_OHCI_HCD? n
  USB_PEGASUS? n
  USB_R8A66597_HCD? n
  USB_RTL8150? n
  USB_SL811_CS? n
  USB_SL811_HCD? n
  USB_U132_HCD? n
  USB_UHCI_HCD? n
  USB_USBNET? n
  USB_XHCI_HCD? n
  USB_ZD1201? n
  YENTA? n
  ZD1211RW? n


  ${kernelPlatform.kernelExtraConfig or ""}
  ${extraConfig}
''
