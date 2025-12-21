# Active Directory Homelab

This homelab uses Oracle VirtualBox to deploy a Windows Server domain controller and a Windows client machine, with dual NICs configured for NAT and internal networking. Active Directory Domain Services, NAT/RAS, and DHCP are set up to create a new forest, manage organizational units, and provide network access for both internal and external connectivity. Optional Python and PowerShell scripts automate user creation and management, simulating enterprise Active Directory operations in a controlled lab environment.

# Steps: 

**Step 1: Set up the domain controller VM**

Download and install Oracle VirtualBox and obtain both ISO files for [Windows Server 2022](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022) and [Windows 11](https://www.microsoft.com/en-us/software-download/windows11). Create the VM for the domain controller in VirtualBox by clicking "New" -> select the Windows Server 2022 ISO -> select "Skip Unattended Installation" -> assign appropriate CPU, RAM, and storage based on your system -> configure two network adapters (NAT & Internal Network).

<img src="Step-Images/step1-0.jpg" width="900"/>
<img src="Step-Images/step1-1.jpg" width="900"/>
<img src="Step-Images/step1-2.jpg" width="900"/>

**Step 2: Install and Configure Windows Server 2022**

Install Windows Server Standard Evaluation (Desktop Experience), select the unallocated partition, and set an administrator password. Once signed into the admin account, enable guest editions via "Devices" -> "Insert Guest Additions CD Image..." -> via File Explorer select "CD Drive (D:)..." -> "VBox WindowsAdditions-amd64" -> select manual reboot after installation is complete. Next will be renaming and assigning addresses to the two NICs which could be accessed via Settings -> Network & Internet -> Ethernet -> Change adapter options. Both NICs should be renamed to easily identify the one connected to home internet and the internal network. The internal network NIC can be identified via right-click -> Status -> check for APIPA address of 169.254.X.X. This should be changed via Properties -> IPv4 (Properties) -> IP Address: 172.16.0.1 Subnet Mask: 255.255.255.0 Preferred DNS Server: 127.0.0.1. The home internet NIC can remain unchanged. Lastly, rename the system via Settings -> System -> About -> Rename this PC -> Restart now. 

<img src="Step-Images/step2-0.jpg" width="900"/>
<img src="Step-Images/step2-1.png" width="900"/>
<img src="Step-Images/step2-2.png" width="900"/>
<img src="Step-Images/step2-3.png" width="900"/>
<img src="Step-Images/step2-4.png" width="900"/>
<img src="Step-Images/step2-5.png" width="900"/>
