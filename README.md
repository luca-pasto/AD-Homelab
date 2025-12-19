# Active Directory Homelab

This homelab uses Oracle VirtualBox to deploy a Windows Server domain controller and a Windows client machine, with dual NICs configured for NAT and internal networking. Active Directory Domain Services, NAT/RAS, and DHCP are set up to create a new forest, manage organizational units, and provide network access for both internal and external connectivity. Optional Python and PowerShell scripts automate user creation and management, simulating enterprise Active Directory operations in a controlled lab environment.

# Steps: 

**Step 1: Set up the domain controller VM**

Download and install Oracle VirtualBox and obtain both ISO files for [Windows Server 2022](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022) and [Windows 11](https://www.microsoft.com/en-us/software-download/windows11). Create the VM for the domain controller in VirtualBox by clicking "New" -> select the Windows Server 2022 ISO -> select "Skip Unattended Installation" -> assign appropriate CPU, RAM, and storage based on your system -> configure two network adapters (NAT & Internal Network).

<img src="Step-Images/step1-0.jpg" width="900"/>
<img src="Step-Images/step1-1.jpg" width="900"/>
<img src="Step-Images/step1-2.jpg" width="900"/>

