### 企业私有云:虚拟化技术

![](https://i.loli.net/2019/06/04/5cf61b854224d74429.png)



#### 虚拟化技术概述

```
虚拟化（Virtualization）技术最早出现在 20 世纪 60 年代的 IBM 大型机系统，在70年代的 System 370 系列中逐渐流行起来，这些机器通过一种叫虚拟机监控器（Virtual Machine Monitor，VMM）的程序在物理硬件之上生成许多可以运行独立操作系统软件的虚拟机（Virtual Machine）实例。随着近年多核系统、集群、网格甚至云计算的广泛部署，虚拟化技术在商业应用上的优势日益体现，不仅降低了 IT 成本，而且还增强了系统安全性和可靠性，虚拟化的概念也逐渐深入到人们日常的工作与生活中。
 
虚拟化是一个广义的术语，对于不同的人来说可能意味着不同的东西，这要取决他们所处的环境。在计算机科学领域中，虚拟化代表着对计算资源的抽象，而不仅仅局限于虚拟机的概念。例如对物理内存的抽象，产生了虚拟内存技术，使得应用程序认为其自身拥有连续可用的地址空间（Address Space），而实际上，应用程序的代码和数据可能是被分隔成多个碎片页或段），甚至被交换到磁盘、闪存等外部存储器上，即使物理内存不足，应用程序也能顺利执行。

```

#### 主流虚拟化方案介绍

```
虚拟化技术主要分为以下几个大类：
 
平台虚拟化（Platform Virtualization），针对计算机和操作系统的虚拟化。
资源虚拟化（Resource Virtualization），针对特定的系统资源的虚拟化，比如内存、存储、网络资源等。
应用程序虚拟化（Application Virtualization），包括仿真、模拟、解释技术等。

    我们通常所说的虚拟化主要是指平台虚拟化技术，通过使用控制程序（Control Program，也被称为 Virtual Machine Monitor 或Hypervisor），隐藏特定计算平台的实际物理特性，为用户提供抽象的、统一的、模拟的计算环境（称为虚拟机）。虚拟机中运行的操作系统被称为客户机操作系统（Guest OS），运行虚拟机监控器的操作系统被称为主机操作系统（Host OS），当然某些虚拟机监控器可以脱离操作系统直接运行在硬件之上（如 VMWARE 的 ESX 产品）。运行虚拟机的真实系统我们称之为主机系统。

平台虚拟化技术又可以细分为如下几个子类：
操作系统级虚拟化（Operating System Level Virtualization） 
    在传统操作系统中，所有用户的进程本质上是在同一个操作系统的实例中运行，因此内核或应用程序的缺陷可能影响到其它进程。操作系统级虚拟化是一种在服务器操作系统中使用的轻量级的虚拟化技术，内核通过创建多个虚拟的操作系统实例（内核和库）来隔离不同的进程，不同实例中的进程完全不了解对方的存在。比较著名的有 Solaris Container，FreeBSD Jail 和 OpenVZ 等。 
    比如OPENVZ：这个平台是最便宜的VPS平台，在各个vps商哪里都是价格最低的。OPENVZ本身运行在linux之上，它通过自己的虚拟化技术把一个服务器虚拟化成多个可以分别安装操作系统的实例，这样的每一个实体就是一个VPS，从客户的角度来看这就是一个虚拟的服务器，可以等同看做一台独立的服务器。OPENVZ虚拟化出来的VPS只能安装linux操作系统，不能安装windows系统，比如Centos、Fedora、Gentoo、Debian等。不能安装windows操作系统是openvz的第一个缺点，需要使用windows平台的用户不能使用OPENVZVPS。OPENVZ的第二个缺点是OPENVZ不是完全的虚拟化，每个VPS账户共用母机内核，不能单独修改内核。好在绝大多少用户根本不需要修改内核，所以这个缺点对多数人可以忽略不计。而这一点也正是openvz的优点，这一共用内核特性使得openvz的效率最高，超过KVM、Xen、VMware等平台。在不超售的情况下，openvz是最快速效率最高的VPS平台。

部分虚拟化（Partial Virtualization） 
    VMM 只模拟部分底层硬件，因此客户机操作系统不做修改是无法在虚拟机中运行的，其它程序可能也需要进行修改。在历史上，部分虚拟化是通往全虚拟化道路上的重要里程碑,最早出现在第一代的分时系统 CTSS 和 IBM M44/44X 实验性的分页系统中。

全虚拟化（Full Virtualization） 
    全虚拟化是指虚拟机模拟了完整的底层硬件，包括处理器、物理内存、时钟、外设等，使得为原始硬件设计的操作系统或其它系统软件完全不做任何修改就可以在虚拟机中运行。操作系统与真实硬件之间的交互可以看成是通过一个预先规定的硬件接口进行的。全虚拟化 VMM 以完整模拟硬件的方式提供全部接口（同时还必须模拟特权指令的执行过程）。举例而言，x86 体系结构中，对于操作系统切换进程页表的操作，真实硬件通过提供一个特权 CR3 寄存器来实现该接口，操作系统只需执行 "mov pgtable,%%cr3"汇编指令即可。全虚拟化 VMM 必须完整地模拟该接口执行的全过程。如果硬件不提供虚拟化的特殊支持，那么这个模拟过程将会十分复杂：一般而言，VMM 必须运行在最高优先级来完全控制主机系统，而 Guest OS 需要降级运行，从而不能执行特权操作。当 Guest OS 执行前面的特权汇编指令时，主机系统产生异常（General Protection Exception），执行控制权重新从 Guest OS 转到 VMM 手中。VMM 事先分配一个变量作为影子 CR3 寄存器给 Guest OS，将 pgtable 代表的客户机物理地址（Guest Physical Address）填入影子 CR3 寄存器，然后 VMM 还需要 pgtable 翻译成主机物理地址（Host Physical Address）并填入物理 CR3 寄存器，最后返回到 Guest OS中。随后 VMM 还将处理复杂的 Guest OS 缺页异常（Page Fault）。比较著名的全虚拟化 VMM 有 Microsoft Virtual PC、VMware Workstation、Sun Virtual Box、Parallels Desktop for Mac 和 QEMU。

超虚拟化（Paravirtualization） 
    这是一种修改 Guest OS 部分访问特权状态的代码以便直接与 VMM 交互的技术。在超虚拟化虚拟机中，部分硬件接口以软件的形式提供给客户机操作系统，这可以通过 Hypercall（VMM 提供给 Guest OS 的直接调用，与系统调用类似）的方式来提供。例如，Guest OS 把切换页表的代码修改为调用 Hypercall 来直接完成修改影子 CR3 寄存器和翻译地址的工作。由于不需要产生额外的异常和模拟部分硬件执行流程，超虚拟化可以大幅度提高性能，比较著名的 VMM 有 Denali、Xen。
 
硬件辅助虚拟化（Hardware-Assisted Virtualization） 
    硬件辅助虚拟化是指借助硬件（主要是主机处理器）的支持来实现高效的全虚拟化。例如有了 Intel-VT 技术的支持，Guest OS 和 VMM 的执行环境自动地完全隔离开来，Guest OS 有自己的""套寄存器"，可以直接运行在最高级别。因此在上面的例子中，Guest OS 能够执行修改页表的汇编指令。Intel-VT 和 AMD-V 是目前 x86 体系结构上可用的两种硬件辅助虚拟化技术。
 
这种分类并不是绝对的，一个优秀的虚拟化软件往往融合了多项技术。例如 VMware Workstation 是一个著名的全虚拟化的 VMM，但是它使用了一种被称为动态二进制翻译的技术把对特权状态的访问转换成对影子状态的操作，从而避免了低效的 Trap-And-Emulate 的处理方式，这与超虚拟化相似，只不过超虚拟化是静态地修改程序代码。对于超虚拟化而言，如果能利用硬件特性，那么虚拟机的管理将会大大简化，同时还能保持较高的性能。
```

#### KVM虚拟化技术简介

##### kvm架构图

![](https://i.loli.net/2019/06/04/5cf61ba84b46f24553.jpeg)

```
    从rhel6开始使用 直接把kvm的模块做成了内核的一部分
    xen用在rhel6之前的企业版中 默认内核不支持，需要重新安装带xen功能的内核
    KVM 针对运行在 x86 硬件上的、驻留在内核中的虚拟化基础结构。KVM 是第一个成为原生 Linux 内核（2.6.20）的一部分的 hypervisor，它是由 Avi Kivity 开发和维护的，现在归 Red Hat 所有。
    这个 hypervisor 提供 x86 虚拟化，同时拥有到 PowerPC® 和 IA64 的通道。另外，KVM 最近还添加了对对称多处理（SMP）主机（和来宾）的支持，并且支持企业级特性，比如活动迁移（允许来宾操作系统在物理服务器之间迁移）。
    KVM 是作为内核模块实现的，因此 Linux 只要加载该模块就会成为一个hypervisor。KVM 为支持 hypervisor  指令的硬件平台提供完整的虚拟化（比如 Intel® Virtualization Technology [Intel VT] 或 AMD  Virtualization [AMD-V] 产品）。KVM 还支持准虚拟化来宾操作系统，包括 Linux 和 Windows®。
    这种技术由两个组件实现。第一个是可加载的 KVM 模块，当在 Linux 内核安装该模块之后，它就可以管理虚拟化硬件，并通过 /proc  文件系统公开其功能。第二个组件用于 PC 平台模拟，它是由修改版 QEMU 提供的。QEMU  作为用户空间进程执行，并且在来宾操作系统请求方面与内核协调。 

    当新的操作系统在 KVM 上启动时（通过一个称为 kvm 的实用程序），它就成为宿主操作系统的一个进程，因此就可以像其他进程一样调度它。但与传统的 Linux 进程不一样，来宾操作系统被 hypervisor 标识为处于 "来宾" 模式（独立于内核和用户模式）。
    每个来宾操作系统都是通过 /dev/kvm 设备映射的，它们拥有自己的虚拟地址空间，该空间映射到主机内核的物理地址空间。如前所述，KVM 使用底层硬件的虚拟化支持来提供完整的（原生）虚拟化。I/O 请求通过主机内核映射到在主机上（hypervisor）执行的 QEMU 进程。
    KVM 在 Linux 环境中以主机的方式运行，不过只要底层硬件虚拟化支持，它就能够支持大量的来宾操作系统.
```

#### KVM安装

```
查看CPU是否支持VT技术: 
    #cat /proc/cpuinfo | grep -E 'vmx|svm'   
     flags : fpu vme de pse tsc msr pae mce cx8 apicmtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2
     ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx tm2 ssse3 cx16
     xtpr pdcm dca sse4_1 lahf_lm dts tpr_shadow vnmi flexpriority

需求内核(rhel6以上):   
    # uname  -r
    2.6.32-358.el6.x86_64 
   
升级系统：(在安装虚拟机出错的情况下)
    # yum upgrade

安装软件:
   yum install qemu-kvm libvirt virt-manager librbd1-devel -y    
    
启动服务:    
    centos7:
    # systemctl start libvirtd
    
查看kvm模块加载:
    # lsmod | grep kvm
        kvm_intel              53484  3 
        kvm                   316506  1 kvm_intel
```

#### KVM gustos部署安装

```
图形模式安装guest os
    #virt-manager
====================
先关闭iptables firewalld/SELinux
安装一个ftp
yum -y install vsftpd
systemctl start vsftpd
systemctl enable vsftpd
然后配置ftp配置文件
vim /etc/vsftpd/vsftpd.conf
anonymous_enable=YES           //是否允许匿名用户登录ftp
chroot_local_user=YES         //所有本地用户chroot

创建一个共享文件
mkdir /var/ftp/centos7u5
echo “mount -o loop /home/CentOS-7-x86_64-DVD-1810.iso /var/ftp/centos7u5”  >> /etc/rc.local
chmod +x /etc/rc.d/rc.local
把镜像挂载到ftp上
mount -o loop /home/CentOS-7-x86_64-DVD-1810.iso /var/ftp/centos7u5
chmod 755 /var/ftp/centos7u5
完全文本方式安装:
yum install -y virt-install
#virt-install --connect qemu:///system -n vm1 -r 2050 --disk path=/var/lib/libvirt/images/vm1.img,size=7  --os-type=linux --os-variant=centos7.0 --vcpus=2  --location=ftp://10.3.138.124/centos7u3 -x console=ttyS0 --nographics


qemu:///system  If running on a bare metal kernel as root (needed for KVM installs)
-n name
-r  以M为单位指定分配给虚拟机的内存大小
--disk 指定作为客户机存储的媒介 size以G为单位的存储
--os-type   针对一类操作系统优化虚拟机配置
--os-variant 针对特定操作系统变体进一步优化虚拟机配置
--vcpus
--location  客户虚拟机kernel+initrd 安装源，必须为镜像挂载在ftp目录下
-x 当执行从”–location”选项指定位置的客户机安装时，附加内核命令行参数到安装程序
--nographics 指定没有控制台被分配给客户机。

缺点：纯文本安装的输入时大小写莫名的变换，远程ssh没问题
     内存必须大于2048

排错:
    安装过程中：
        手动配置IP地址
        到url位置找不到路径，要返回去手动选择url，重新配置url为ftp://192.168.100.230/rhel6u4,这里的ip不要写127.0.0.1而是br0的ip
        
====================
模板镜像+配置文件 方式创建虚拟机
# virsh define /etc/libvirt/qemu/vm2.xml

1.拷贝模板镜像和配置文件
[root@kvm ~]# cp /var/lib/libvirt/images/vm1.img /var/lib/libvirt/images/vm2.img
[root@kvm ~]# cp /etc/libvirt/qemu/vm1.xml /etc/libvirt/qemu/vm2.xml

2.修改配置文件
主要就是修改name、UUID、source file路径、mac address
# vim /etc/libvirt/qemu/vm2.xml
<domain type='kvm'>
  <name>vm2</name>
  <uuid>a2f62549-c6b7-4b8f-a8e2-c14edda35a78</uuid>
  <memory unit='KiB'>2099200</memory>
  <currentMemory unit='KiB'>2099200</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='custom' match='exact' check='partial'>
    <model fallback='allow'>Haswell-noTSX</model>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/vm2.img'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
    </disk>
    <controller type='usb' index='0' model='ich9-ehci1'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x7'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci1'>
      <master startport='0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0' multifunction='on'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci2'>
      <master startport='2'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x1'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci3'>
      <master startport='4'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </controller>
    <interface type='network'>
      <mac address='52:54:00:f2:28:6f'/>
      <source network='default'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </memballoon>
  </devices>
</domain>

virsh define /etc/libvirt/qemu/vm2.xml
```

#### KVM虚拟机管理

```
==================
虚拟机的组成部分
1.虚拟机配置文件
[root@localhost qemu]# ls /etc/libvirt/qemu
networks  vm1.xml
2.储存虚拟机的介质
[root@localhost qemu]# ls /var/lib/libvirt/images/
vm1.img
==================
虚拟机的基本管理命令：
查看
启动
关闭
重启
重置 

查看:
查看虚拟机:
    # virsh list 
     Id    Name                           State
    ----------------------------------------------------
     2     vm1                            running

    # virsh list --all
     Id    Name                           State
    ----------------------------------------------------
     2     vm1                            running

查看kvm虚拟机配置文件：
#virsh dumpxml name

将node4虚拟机的配置文件保存至node6.xml
#virsh dumpxml node4 > /etc/libvirt/qemu/node6.xml

修改node6的配置文件：
#virsh edit node6      
如果直接用vim编辑器修改配置文件的话，需要重启libvirtd服务

启动:
[root@localhost ~]# virsh start vm1
Domain vm1 started

暂停虚拟机： 
  #virsh suspend vm_name  

恢复虚拟机：
  #virsh resume vm_name    
  
关闭：
    方法1：
    # virsh shutdown vm1
    Domain vm1 is being shutdown
    方法2：
    # virsh destroy vm1
    Domain vm1 destroyed

重启：
    [root@localhost ~]# virsh reboot vm1
    Domain vm1 is being reboote

重置:
    [root@localhost ~]# virsh reset vm1
    Domain vm1 was reset

删除虚拟机:
# virsh undefine vm2
Domain vm2 has been undefined

注意:虚拟机在开启的情况下undefine是无法删除的，但是如果再destroy会直接被删除掉
======================

虚拟机开机自动启动:
    # virsh autostart vm1
        域 vm1标记为自动开始
    # ls /etc/libvirt/qemu/autostart/     //此目录默认不存在，在有开机启动的虚拟机时自动创建
        vm1.xml

    # virsh autostart --disable vm1
        域 vm1取消标记为自动开始
    # ls /etc/libvirt/qemu/autostart/
    
获取虚拟机IP
方式一：
   # virsh domifaddr vm1
 Name       MAC address          Protocol     Address
-------------------------------------------------------------------------------
 vnet0      52:54:00:56:6c:e1    ipv4         192.168.122.88/24
方式二：
# virsh dumpxml vm1 |grep 'mac address'
      <mac address='52:54:00:56:6c:e1'/>
# arp -a |grep "52:54:00:56:6c:e1"
vm1 (192.168.122.88) at 52:54:00:56:6c:e1 [ether] on virbr0
```



#### 虚拟机添加设备

```
给虚拟机添加新硬件：
图形方式:
    首先，关闭要添加硬件的虚拟机
    双击虚拟机，在打开的对话框点击上方的View，点击Details，点击Add Hardware可以选择要添加的虚拟硬件
 
 
修改配置文件方式:
<domain type='kvm'>
  <name>vm2</name>
  <uuid>d0bc50b6-6acc-432b-9953-bc47b2b4aa87</uuid>
  <memory unit='KiB'>1024000</memory>
  <currentMemory unit='KiB'>1024000</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='custom' match='exact' check='partial'>
    <model fallback='allow'>Haswell-noTSX</model>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>

    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/vm2.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </disk>
    
    
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/vm2-1.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x17' function='0x0'/>
    </disk>    
    
    
    
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <target dev='hda' bus='ide'/>
      <readonly/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>
    
    <controller type='usb' index='0' model='ich9-ehci1'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x7'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci1'>
      <master startport='0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0' multifunction='on'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci2'>
      <master startport='2'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x1'/>
    </controller>
    <controller type='usb' index='0' model='ich9-uhci3'>
      <master startport='4'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='ide' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
    </controller>
    
    <interface type='network'>
      <mac address='52:54:00:04:63:6a'/>
      <source network='default'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
    
    <interface type='network'>
      <mac address='52:54:00:04:63:6'/>
      <source network='default'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x13' function='0x0'/>
    </interface>
    
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='2'/>
    </channel>
    <input type='tablet' bus='usb'>
      <address type='usb' bus='0' port='1'/>
    </input>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='spice' autoport='yes'>
      <listen type='address'/>
      <image compression='off'/>
    </graphics>
    <sound model='ich6'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </sound>
    <video>
      <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1' primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='2'/>
    </redirdev>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='3'/>
    </redirdev>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0'/>
    </memballoon>
  </devices>
</domain>
```



```
修改配置文件方式:
[root@kvm images]# cd /etc/libvirt/qemu/
[root@kvm qemu]# cp vm1.xml vm10.xml
[root@kvm qemu]# vim vm10.xml

必须要修改的部分：
guest os的名称：
  <name>vm1</name>

uuid:
  <uuid>78e98d16-a0d0-4002-9dc4-b8ca7d538457</uuid>

磁盘：
     <disk type='file' device='disk'>
       <driver name='qemu' type='qcow2'/>
        <source file='/var/lib/libvirt/images/vm1.qcow2'/>
        <target dev='vda' bus='virtio'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
     </disk>

网卡：     
    <interface type='network'>
      <mac address='52:54:00:fc:c6:0b'/>
      <source network='default'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>

可选部分：
内存：
<memory unit='KiB'>2048000</memory>
  <currentMemory unit='KiB'>2048000</currentMemory>

cpu个数:
  <vcpu placement='static'>2</vcpu>
```

```
1.使用配置文件方式生成一个新虚机
2.修改配置文件给新生成的虚机添加一块硬盘，添加一块网卡
3.使修改的配置文件生效
    方法1：重启libvirtd
    方法2：# virsh define 配置文件
    
    
创建空的磁盘文件：
#qemu-img create -f qcow2 /var/lib/libvirt/images/vm11.qcow2 5G
```



#### 虚拟机克隆

```js
虚拟机克隆
1.图形界面：Applications （左上角）-----> System Tools ------>Virtual Machine Manager
   关闭要克隆的虚拟机，右键点击虚拟机选择Clone

2.字符终端，命令克隆
    # virt-clone -o vm1 --auto-clone
        WARNING  设置图形设备端口为自动端口，以避免相互冲突。
        正在分配 'vm1-clone.qcow2'            | 6.0 GB  00:00:05     
        成功克隆 'vm1-clone'。
    -o       origin    
    
    # virt-clone -o vm1 -n vm2 --auto-clone
        WARNING  设置图形设备端口为自动端口，以避免相互冲突。
        正在分配 'vm2.qcow2'                                                | 6.0 GB  00:00:06     
        成功克隆 'vm2'。
        
    # virt-clone -o vm1 -n vm2 -f /var/lib/libvirt/images/vm2.img
        正在克隆        
        vm1.img              | 8.0 GB     01:03     
        Clone 'vm2' created successfully.
```

#### 高级命令

```js
建立虚拟机磁盘镜像文件：
磁盘镜像文件格式:
    raw     原始格式，性能最好 直接占用你一开始给多少 系统就占多少 不支持快照
    qcow  先去网上了解一下cow(写时拷贝copy on write) ，性能远不能和raw相比，所以很快夭折了，所以出现了qcow2（性能低下 早就被抛弃）
    qcow2 性能上还是不如raw，但是raw不支持快照，qcow2支持快照。

现在默认安装好的用的是raw格式，所有做快照要把他转换成qcow2格式

什么叫写时拷贝？
raw立刻分配空间，不管你有没有用到那么多空间
qcow2只是承诺给你分配空间，但是只有当你需要用空间的时候，才会给你空间。最多只给你承诺空间的大小，避免空间浪费

工作当中用哪个？看你用不用快照。
工作当中虚拟机会有多个备份，一个坏了，再起一个就行了，所有没必要用快照。当然也不一定。
数据绝对不会存储到本地。

qemu-kvm  qemu是早先的一个模拟器，kvm是基于qemu发展出来的。

建立qcow2格式磁盘文件:
#qemu-img create -f qcow2 test.qcow2 20G 

建立raw格式磁盘文件:
#qemu-img create -f raw test.raw 20G  

查看已经创建的虚拟磁盘文件:
#qemu-img info test.qcow2 


==============================
作为虚拟化环境管理员，你肯定遇到过虚拟机无法启动的情况。实施排错时，你需要对虚拟机的内部进行检查。而Libguestfs Linux工具集可以在这种情况下为你提供帮助。
 
利用Libguestfs找出损坏的虚拟机文件
Libguestfs允许在虚拟机上挂载任何类型的文件系统，以便修复启动故障。
使用Libguestfs，首先需要使用Libvirt。Libvirt是一个管理接口，可以和KVM、Xen和其他一些基于Liunx的虚拟机相互连接。Libguestfs的功能更加强大，可以打开Windows虚拟机上的文件。但是首先你需要将虚拟机迁移到libguestfs可用的环境当中，也就是Linux环境。
假如你是vmware的ESXI虚拟机，为了将虚拟机迁移到Linux当中，你可以使用SSH连接到ESXi主机，这意味着你首先需要启用ESXi主机上的SSH访问方式。完成之后，在
Linux平台上运行下面的scp命令：
1. scp –r 192.168.178.30:/vmfs/volumes/datastore1/Windows* 

使用guestfish操作虚拟机磁盘镜像文件：
完成虚拟机磁盘镜像文件的复制之后，可以在libguestfs中使用guestfish这样的工具将其打开，这样就可以直接在vmdk文件上进行操作了。


使用命令来在虚拟机中创建一个连接到文件系统的交互式shell。在新出现的窗口中，你可以使用特定的命令来操作虚拟机文件。
#guestfish --rw -a  /path/to/windows.vmdk

第一个任务就是找到可用的文件系统：
1. ><fs> run                   //进入交互式shell之后第一个命令
2. ><fs> list-filesystems  //列出磁盘镜像文件内的文件系统
/dev/vda1: ext4
/dev/vdb1: iso9660
/dev/VolGroup/lv_root: ext4
/dev/VolGroup/lv_swap: swap
3.><fs>  mount /dev/VolGroup/lv_root    /     //当你使用guestfish shell找到可用文件系统类型之后，就可以进行挂载了。将文件系统到guestfish根目录下
4.><fs>  ls /                                               //ls命令查看文件/下内容 ，不能使用cd命令
bin  boot dev etc home  lib lib64  lost+found
5.><fs> cat /etc/passwd      //查看文件，不能像在其他shell环境中一样操作。目录所有路径必须从根开始
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

在guestfish  shell当中可以使用像ls、cat、more、download这样的命令，来查看和下载文件以及目录

guestfish  读镜像
mount  /dev/sda1  /
cd /



查看帮助：这两个帮助显示的内容不一样
# guestfish --help 
# guestfish -h

Virt-rescue提供直接访问方式：
这种方式跟linux系统光盘的rescue模式几乎一样，进去之后首先需要查看文件系统，然后手动挂载到/sysroot目录下，进入/sysroot目录就可以随意操作虚拟磁盘镜像内的文件了
# virt-rescue vm1         //进入修复模式，help查看帮助
><rescue>fdisk -l
><rescue>mount /dev/mapper/VolGroup-lv_root /sysroot/ 
><rescue>cd /sysroot/
><rescue>touch aaaaaaaaaaaaa

============================
查看磁盘镜像分区信息:
    # virt-df -h -d vm1
    Filesystem                                Size       Used  Available  Use%
    vm1:/dev/sda1                             484M        32M       428M    7%
    vm1:/dev/sdb1                             3.5G       3.5G          0  100%
    vm1:/dev/VolGroup/lv_root                 6.1G       1.1G       4.7G   18%

    # virt-filesystems -d vm1
    /dev/sda1
    /dev/sdb1
    /dev/VolGroup/lv_root

挂载磁盘镜像分区:
    # guestmount -d vm1 -m /dev/vda1 --rw /mnt
    

```



#### 虚拟机使用半虚拟化驱动

```
KVM是必须使用硬件虚拟化辅助技术（如Intel VT-x、AMD-V）的hypervisor，在CPU运行效率方面有硬件支持，其效率是比较高的；在有Intel EPT特性支持的平台上，内存虚拟化的效率也较高。QEMU/KVM提供了全虚拟化环境，可以让客户机不经过任何修改就能运行在KVM环境中。不过，KVM在I/O虚拟化方面，传统的方式是使用QEMU纯软件的方式来模拟I/O设备（如第4章中提到模拟的网卡、磁盘、显卡等等），其效率并不非常高。在KVM中，可以在客户机中使用半虚拟化驱动（Paravirtualized Drivers，PV Drivers）来提高客户机的性能（特别是I/O性能）。目前，KVM中实现半虚拟化驱动的方式是采用了virtio这个Linux上的设备驱动标准框架。
```



#### KVM网络配置

桥接网络

![](https://i.loli.net/2019/06/09/5cfd15ce11ad477500.jpg)



nat网络

![](https://i.loli.net/2019/06/09/5cfd1582763a891926.jpg)



隔离网络



```js
可以通过查看mac地址是否一致来确定是不是一根线上的两个接口
# brctl show
bridge name	bridge id		                STP enabled	 interfaces
virbr0		        8000.5254003c2ba7	yes		         virbr0-nic
							                                                     vnet2
							                                                     vnet3
从交换机上把vnet网卡删除：
# brctl delif  virbr0 vnet0
添加vnet网卡到交换机上：
# brctl addif  virbr0 vnet0
						            
配置文件方式配置桥接：在宿主机上
    1.修改配置文件
    # cat ifcfg-br0 
    TYPE=Bridge
    NAME=br0
    DEVICE=br0
    ONBOOT="yes"
    BOOTPROTO=static
    IPADDR=10.18.44.251
    GATEWAY=10.18.44.1
    NETMASK=255.255.255.0
    DNS1=10.18.44.100
    DNS2=8.8.8.8

    # cat ifcfg-enp3s0
    TYPE="Ethernet"
    NAME="enp3s0"
    DEVICE="enp3s0"
    ONBOOT="yes"
    BRIDGE=br0
    
    2.重启libvirtd服务
    3.重启network服务 
     
    删除桥接网卡步骤：
    1.删除br0的配置文件
    2.修改正常网卡的配置文件
    3.重启系统    
    
配置文件方式创建nat网络：
# cp /etc/libvirt/qemu/networks/nat2.xml /etc/libvirt/qemu/networks/nat3.xml
# vim /etc/libvirt/qemu/networks/nat3.xml
<network>
  <name>nat3</name>
  <uuid>4d8b9b5c-748f-4e16-a509-848202b9c83b</uuid>
  <forward mode='nat'/>             //和隔离模式的区别
  <bridge name='virbr4' stp='on' delay='0'/>
  <mac address='52:57:00:62:0c:d4'/>
  <domain name='nat3'/>
  <ip address='192.168.104.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.104.128' end='192.168.104.254'/>
    </dhcp>
  </ip>
</network>

重启服务：
# systemctl  restart libvirtd

配置文件方式创建isolated网络：           
<network>
  <name>isolate1</name>
  <uuid>6341d3a6-7330-4e45-a8fe-164a6a68929a</uuid>
  <bridge name='virbr2' stp='on' delay='0'/>
  <mac address='52:54:00:6b:39:0c'/>
  <domain name='isolate1'/>
  <ip address='192.168.101.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.101.128' end='192.168.101.254'/>
    </dhcp>
  </ip>
</network>            

查看所有的网络：
# virsh net-list

启动网络：
# virsh net-start isolated200

开机自启动:
# virsh net-autostart  isolated200 
```



#### KVM存储配置

```js
存储池
概念：
    kvm必须要配置一个目录当作他存储磁盘镜像(存储卷)的目录，我们称这个目录为存储池
默认存储池：
    /var/lib/libvirt/images/    
    
    1.创建基于文件夹的存储池（目录）
       # mkdir -p /data/vmfs
    2.定义存储池与其目录
       # virsh pool-define-as vmdisk --type dir --target /data/vmfs
    3.创建已定义的存储池
        (1)创建已定义的存储池
            # virsh pool-build vmdisk
        (2)查看已定义的存储池，存储池不激活无法使用。
            #virsh pool-list --all
    4.激活并自动启动已定义的存储池
        # virsh pool-start vmdisk
        # virsh pool-autostart vmdisk         
        这里vmdisk存储池就已经创建好了，可以直接在这个存储池中创建虚拟磁盘文件了。
    5.在存储池中创建虚拟机存储卷
         # virsh vol-create-as vmdisk oeltest03.qcow2 20G --format qcow2
     
    注1:KVM存储池主要是体现一种管理方式，可以通过挂载存储目录，lvm逻辑卷的方式创建存储池，虚拟机存储卷创建完成后，剩下的操作与无存储卷的方式无任何区别了。
    注2:KVM存储池也要用于虚拟机迁移任务。

    6.存储池相关管理命令
        (1)在存储池中删除虚拟机存储卷
            # virsh vol-delete --pool vmdisk oeltest03.qcow2
        (2)取消激活存储池
            # virsh pool-destroy vmdisk
        (3)删除存储池定义的目录/data/vmfs
            # virsh pool-delete vmdisk
        (4)取消定义存储池
            # virsh pool-undefine vmdisk
到此kvm存储池配置与管理操作完毕。   
```

#### kvm快照

```js
为虚拟机rhel5u8-1创建一个快照
# virsh snapshot-create-as rhel5u8-1 rhel5u8-1.snap
error: unsupported configuration: internal snapshot for disk vda unsupported for storage type raw

raw
使用文件来模拟实际的硬盘(当然也可以使用一块真实的硬盘或一个分区)。由于原生的裸格式，不支持snapshot也是很正常的。但如果你使用LVM的裸设备，那就另当别论。说到LVM还是十分的犀利的目前来LVM的snapshot、性能、可扩展性方面都还是有相当的效果的。目前来看的话，备份的话也问题不大。就是在虚拟机迁移方面还是有很大的限制。但目前虚拟化的现状来看，真正需要热迁移的情况目前需求还不是是否的强烈。虽然使用LVM做虚拟机镜像的相关公开资料比较少，但目前来看牺牲一点灵活性，换取性能和便于管理还是不错的选择。

qcow2
现在比较主流的一种虚拟化镜像格式，经过一代的优化，目前qcow2的性能上接近raw裸格式的性能，这个也算是redhat的官方渠道了
对于qcow2的格式，几点还是比较突出的，qcow2的snapshot，可以在镜像上做N多个快照：
	•更小的存储空间
	•Copy-on-write support
	•支持多个snapshot，对历史snapshot进行管理
	•支持zlib的磁盘压缩
	•支持AES的加密
		
查看镜像文件格式：
# qemu-img info /var/lib/libvirt/images/rhel5u8-1.img 
image: /var/lib/libvirt/images/rhel5u8-1.img
file format: raw
virtual size: 10G (10737418240 bytes)
disk size: 10G

格式转换：
把raw格式转换成qcow2格式
# qemu-img convert -f raw -O qcow2 /var/lib/libvirt/images/rhel5u8-1.img /var/lib/libvirt/images/rhel5u8-1_qcow2.img

#qemu-img convert  -O qcow2 /var/lib/libvirt/images/centos7.0_123.raw /var/lib/libvirt/images/centos7.0_123.qcow2

# ls -l /var/lib/libvirt/images/
total 28381680
-rw-------. 1 qemu qemu 10737418240 Aug 16 01:09 rhel5u8-1.img
-rw-r--r--. 1 root root  3076521984 Aug 16 01:09 rhel5u8-1_qcow2.img

# qemu-img info /var/lib/libvirt/images/rhel5u8-1_qcow2.img 
image: /var/lib/libvirt/images/rhel5u8-1_qcow2.img
file format: qcow2
virtual size: 10G (10737418240 bytes)
disk size: 2.9G
cluster_size: 65536

将虚拟机的硬盘指向转换后的qcow2 img

在虚拟机中创建一个目录，但目录中是空的
# mkdir /test
# ls /test

给虚拟机rhel5u8-1创建第一个镜像rhel5u8-1.snap1
# virsh snapshot-create-as rhel5u8-1 rhel5u8-1.snap1

# qemu-img info /var/lib/libvirt/images/rhel5u8-1_qcow2.img 
image: /var/lib/libvirt/images/rhel5u8-1_qcow2.img
file format: qcow2
virtual size: 10G (10737418240 bytes)
disk size: 3.1G
cluster_size: 65536
Snapshot list:
ID        TAG                 VM SIZE                DATE       VM CLOCK
1         rhel5u8-1.snap1        229M 2013-08-16 01:25:39   00:03:58.995

在虚拟机中，给 /test 中复制2个文件
# cp install.log anaconda-ks.cfg  /test
# ls /test
anaconda-ks.cfg  install.log

给虚拟机rhel5u8-1创建第二个镜像rhel5u8-1.snap2
# virsh snapshot-create-as rhel5u8-1 rhel5u8-1.snap2
Domain snapshot rhel5u8-1.snap2 created
# virsh snapshot-list rhel5u8-1

关闭虚拟机，恢复到第一个快照
# virsh shutdown rhel5u8-1
# virsh snapshot-revert rhel5u8-1 rhel5u8-1.snap1

在虚拟机中，发现 /test 目录为空
# ls /test

关闭虚拟机，恢复到第二个快照
# virsh shutdown rhel5u8-1
# virsh snapshot-revert rhel5u8-1 rhel5u8-1.snap2

在虚拟机中，发现 /test 有拷贝的2个文件
# ls /test
anaconda-ks.cfg  install.log

删除虚拟机快照
# virsh snapshot-list rhel5u8-1

# virsh snapshot-delete --snapshotname rhel5u8-1.snap2 rhel5u8-1

# virsh snapshot-list rhel5u8-1

```

#### kvm迁移

```js
10.18.42.202 


10.18.42.46

热迁移

				192.168.1.1/24	            192.168.1.2/24
				++++++++++++            	++++++++++++
				+			+			    +		    +		
				+    KVM-A  +  =======>     +	KVM-B 	+
				+	    	+			    +	        +	
				++++++++++++				++++++++++++
			images                              images
		/var/lib/libvirt/images	          /var/lib/libvirt/images                   
				
				                                         nfs
			
系统环境:rhel6.4 x86_64 iptables and selinux off



注意：
    1.两台机器要做互相解析	
	2.同一个大版本的系统，从高版本系统上不可以往低版本系统上迁移，反过来可以比如从6.5不能迁移到6.4，但是从6.4可以迁移到6.5
	3.两台机器的selinux全部开机关闭
	
将 KVM-A 上的虚拟机镜像文件所在的目录共享出来
[root@localhost ~]# getenforce 
Permissive
[root@localhost ~]# iptables -F
[root@localhost ~]# vim /etc/exports 
/var/lib/libvirt/images 192.168.1.2(rw,sync,no_root_squash)
[root@localhost ~]# service nfs start

将KVM-A上共享出来的目录挂载在到KVM-B的/var/lib/libvirt/images
[root@localhost ~]# mount -t nfs 192.168.1.1:/var/lib/libvirt/images  /var/lib/libvirt/images
								
在KVM-B配置/etc/libvirt/qemu.conf
[root@localhost ~]# vim /etc/libvirt/qemu.conf          #取消下面选项的注释
user = "root"		第198行
group = "root"	第202行

[root@localhost ~]# serivice libvirtd restart

在KVM-A上用虚拟机管理器连接KVM-B
File---------> Add Connection

右键点击要迁移的虚拟机，选择 Migrate

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3台机器：
    10.18.41.159   kvmA
    10.18.41.196   kvmB   csyf521
    10.18.41.183   nfs

```



#### 自动化脚本管理kvm

```shell
#!/bin/bash
#kvm batch create vm tool
#version:0.1
#author:name
#需要事先准备模板镜像和配置文件模板
echo "1.创建自定义配置单个虚拟机
2.批量创建自定义配置虚拟机
3.批量创建默认配置虚拟机
4.删除虚拟机"

read -p "选取你的操作(1/2/3):" op

batch_self_define() {

        kvmname=`openssl rand -hex 5`

        sourceimage=/var/lib/libvirt/images/vmmodel.img
        sourcexml=/etc/libvirt/qemu/vmmodel.xml

        newimg=/var/lib/libvirt/images/${kvmname}.img
        newxml=/etc/libvirt/qemu/${kvmname}.xml

        cp $sourceimage  $newimg
        cp $sourcexml $newxml

        kvmuuid=`uuidgen`
        kvmmem=${1}000000
        kvmcpu=$2
        kvmimg=$newimg
        kvmmac=`openssl rand -hex 3 | sed -r 's/..\B/&:/g'`

        sed -i "s@kvmname@$kvmname@;s@kvmuuid@$kvmuuid@;s@kvmmem@$kvmmem@;s@kvmcpu@$kvmcpu@;s@kvmimg@$kvmimg@;s@kvmmac@$kvmmac@" $newxml
        virsh define $newxml
        virsh list --all
}
self_define() {
        read -p "请输入新虚机名称:" newname
        read -p "请输入新虚机内存大小(G):" newmem
        read -p "请输入新虚机cpu个数:" newcpu

        sourceimage=/var/lib/libvirt/images/vmmodel.img
        sourcexml=/etc/libvirt/qemu/vmmodel.xml

        newimg=/var/lib/libvirt/images/${newname}.img
        newxml=/etc/libvirt/qemu/${newname}.xml

        cp $sourceimage  $newimg
        cp $sourcexml $newxml

        kvmname=$newname
        kvmuuid=`uuidgen`
        kvmmem=${newmem}000000
        kvmcpu=$newcpu
        kvmimg=$newimg
        kvmmac=`openssl rand -hex 3 | sed -r 's/..\B/&:/g'`

        sed -i "s@kvmname@$kvmname@;s@kvmuuid@$kvmuuid@;s@kvmmem@$kvmmem@;s@kvmcpu@$kvmcpu@;s@kvmimg@$kvmimg@;s@kvmmac@$kvmmac@" $newxml
        virsh define $newxml
        virsh list --all
}

case $op in
1)self_define;;
2)
        read -p "请输入要创建的虚拟机的个数:" num
        read -p "请输入新虚机内存大小(G):" newmem
        read -p "请输入新虚机cpu个数:" newcpu

        for((i=1;i<=$num;i++))
        do
                batch_self_define $newmem $newcpu
        done;;

3)
        read -p "请输入要创建的虚拟机的个数:" num

        for((i=1;i<=$num;i++))
        do
                batch_self_define 1 1
        done;;

*)echo "输入错误，请重新执行脚本"
  exit;;
esac
```

------

