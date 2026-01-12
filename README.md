# Active Directory Home Lab (Windows Server 2022)

## Description
This home lab demonstrates the deployment of a Windows Server–based Active Directory environment using Oracle VirtualBox. A Windows Server 2022 domain controller and a Windows 11 Pro client are configured with dual network adapters (NAT and Internal Network) to simulate enterprise-style internal and external connectivity. Core services include Active Directory Domain Services (AD DS), NAT/RAS, and DHCP. Optional PowerShell and Python scripts automate user creation to mirror real-world administrative workflows.

---

## Table of Contents
1. [Set Up the Domain Controller VM](#step-1-set-up-the-domain-controller-vm)
2. [Install and Configure Windows Server 2022](#step-2-install-and-configure-windows-server-2022)
3. [Install and Configure Active Directory](#step-3-install-and-configure-active-directory)
4. [Create an Admin Account](#step-4-create-an-admin-account)
5. [Configure NAT and Routing](#step-5-configure-nat-and-routing)
6. [Configure DHCP](#step-6-configure-dhcp)
7. [Create Users (Manual or Scripted)](#step-7-create-users-manual-or-scripted)
8. [Create a Windows 11 Client VM](#step-8-create-a-windows-11-client-vm)
9. [Join the Client to the Domain](#step-9-join-the-client-to-the-domain)
10. [Conclusion](#step-10-conclusion)

---

## Technologies Used
- Oracle VirtualBox
- Windows Server 2022
- Windows 11 Pro
- Active Directory Domain Services
- DHCP/NAT/RAS
- PowerShell/Python

---

## Step 1: Set Up the Domain Controller VM
Create a new virtual machine in Oracle VirtualBox using the Windows Server 2022 ISO. Allocate system resources based on host capacity (recommended: 4 CPU cores, 4 GB RAM). Configure two network adapters:

- **Adapter 1:** NAT (internet access)
- **Adapter 2:** Internal Network (domain communication)

Navigation path:
`VirtualBox > New > ISO Image > Skip Unattended Installation`

<img src="Step-Images/step1-1.jpg" width="900"/>
<img src="Step-Images/step1-2.jpg" width="900"/>

---

## Step 2: Install and Configure Windows Server 2022
Boot the VM and complete the Windows Server installation using **Windows Server 2022 Standard (Desktop Experience)**. After installation:

1. Install VirtualBox Guest Additions for improved usability.
2. Identify network adapters and rename them for clarity.
3. Assign a static IPv4 address to the internal adapter:
4. Rename the system (e.g., `DC1`) and reboot.

Navigation path:
`Settings > Network & Internet > Ethernet > Change adapter options`

```text
IP Address: 172.16.0.1
Subnet Mask: 255.255.255.0
DNS Server: 127.0.0.1
```
<img src="Step-Images/step2-1.png" width="900"/>
<img src="Step-Images/step2-2.png" width="900"/>
<img src="Step-Images/step2-3.png" width="900"/>
<img src="Step-Images/step2-4.png" width="900"/>

---

## Step 3: Install and Configure Active Directory
Install the **Active Directory Domain Services** role via Server Manager and promote the server to a domain controller.

Key configuration:
- Deployment type: **Add a new forest**
- Root domain name: custom (e.g., `mydomain.com`)
- Configure a DSRM password

After reboot, confirm the domain by logging in as:

```text
MYDOMAIN\Administrator
```
<img src="Step-Images/step3-0.png" width="900"/>
<img src="Step-Images/step3-1.png" width="900"/>
<img src="Step-Images/step3-2.png" width="900"/>
<img src="Step-Images/step3-3.png" width="900"/>

---

## Step 4: Create an Admin Account
To follow least-privilege best practices, create a separate administrative user.

Steps:
- Create an Organizational Unit (OU)
- Create a new user within the OU
- Add the user to the **Domain Admins** group

Navigation path:
`Server Manager > Tools > Active Directory Users and Computers`

<img src="Step-Images/step4-1.png" width="900"/>
<img src="Step-Images/step4-2.png" width="900"/>
<img src="Step-Images/step4-4.png" width="900"/>
<img src="Step-Images/step4-6.png" width="900"/>

---

## Step 5: Configure NAT and Routing
Install the **Remote Access** role with the **Routing** service enabled. Configure NAT to allow internal clients to reach external networks.

Key steps:
- Enable Routing and Remote Access
- Select the NAT option
- Assign the public (NAT) interface

<img src="Step-Images/step5-0.png" width="900"/>
<img src="Step-Images/step5-1.png" width="900"/>
<img src="Step-Images/step5-2.png" width="900"/>
<img src="Step-Images/step5-3.png" width="900"/>
<img src="Step-Images/step5-4.png" width="900"/>
<img src="Step-Images/step5-6.png" width="900"/>

---

## Step 6: Configure DHCP
Install the DHCP Server role and configure a scope for internal clients.

Example scope configuration:

```text
Range: 172.16.0.100 – 172.16.0.200
Subnet Mask: 255.255.255.0
Default Gateway: 172.16.0.1
```

Authorize the DHCP server in Active Directory and verify lease assignment.

<img src="Step-Images/step6-0.png" width="900"/>
<img src="Step-Images/step6-1.png" width="900"/>
<img src="Step-Images/step6-2.png" width="900"/>
<img src="Step-Images/step6-3.png" width="900"/>
<img src="Step-Images/step6-4.png" width="900"/>
<img src="Step-Images/step6-5.png" width="900"/>
<img src="Step-Images/step6-6.png" width="900"/>
<img src="Step-Images/step6-7.png" width="900"/>

---

## Step 7: Create Users (Manual or Scripted)
Standard users can be created manually through **Active Directory Users and Computers** or automatically using PowerShell.

### Scripted Approach
The provided PowerShell script:
- Reads names from a `names.txt` file
- Generates standardized usernames
- Detects and resolves duplicates
- Creates users in a specified OU

To run the script:

```powershell
Set-ExecutionPolicy Unrestricted
```

Python can optionally be used to generate the `names.txt` file (e.g., scraping NBA roster data).

<img src="Step-Images/step7-0.png" width="900"/>
<img src="Step-Images/step7-1.png" width="900"/>
<img src="Step-Images/step7-2.png" width="900"/>

---

## Step 8: Create a Windows 11 Client VM
Create a Windows 11 Pro VM using the Windows 11 ISO. Configure the VM with a single **Internal Network** adapter and set it to disabled.

During setup:
- Bypass Microsoft account creation using `OOBE\BYPASSNRO`
- Complete setup with a local account
- Enable the internal adapter after reaching the desktop

<img src="Step-Images/step8-0.png" width="900"/>
<img src="Step-Images/step8-1.png" width="900"/>

---

## Step 9: Join the Client to the Domain
Join the Windows 11 client to the domain using domain credentials.

Navigation path:
`Settings > System > About > Advanced system settings > Computer Name > Change`

Restart the system when prompted.

<img src="Step-Images/step9-0.png" width="900"/>
<img src="Step-Images/step9-1.png" width="900"/>

---

## Step 10: Conclusion
After joining the domain, sign in using a domain user account. Verify:

- Internet access (e.g., `ping google.com`)
- DHCP lease assignment on the domain controller

This concludes the Active Directory home lab, demonstrating core Windows Server administration and automation concepts in a controlled environment.

<img src="Step-Images/step9-2.png" width="900"/>
<img src="Step-Images/step9-3.png" width="900"/>

