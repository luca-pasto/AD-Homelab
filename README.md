# Active Directory: Installation and Configuration

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

**Instruction:** 

Create a new virtual machine in Oracle VirtualBox using the Windows Server 2022 ISO. Allocate system resources based on host capacity (Used: 4 CPU cores, 4 GB RAM). Configure two network adapters:

- **Adapter 1:** NAT (Internet Access) 
- **Adapter 2:** Internal Network (Private Network)

Navigation Path:

`VirtualBox > New > ISO Image > Skip Unattended Installation`

**Objective:**

This step creates the main server that everything else in the lab will connect to. It will manage user logins, computers, and basic network services. Two network connections are used so the server can access the internet while keeping internal network traffic separate, similar to how real business networks operate.

<img src="Step-Images/step1-1.jpg" width="900"/>
<img src="Step-Images/step1-2.jpg" width="900"/>

---

## Step 2: Install and Configure Windows Server 2022

**Instruction:** 

Boot the VM and complete the Windows Server installation using **Windows Server 2022 Standard (Desktop Experience)**. After installation:

1. Install VirtualBox Guest Additions for improved usability.
2. Identify network adapters and rename them for clarity.
3. Assign a static IPv4 address to the internal network adapter.
4. Rename the system (e.g., `DC1`) and reboot.

Navigation Path:

`Settings > Network & Internet > Ethernet > Change adapter options`

```
IP Address: 172.16.0.1
Subnet Mask: 255.255.255.0
DNS Server: 127.0.0.1
```

**Objective:**

Here the operating system is installed that will allow the server to run all other services. It is assigned a static IP address to ensure that it can reliably be found on the network for future client computers. It is then renamed for easier identification within the environment. 

<img src="Step-Images/step2-1.png" width="900"/>
<img src="Step-Images/step2-2.png" width="900"/>
<img src="Step-Images/step2-3.png" width="900"/>
<img src="Step-Images/step2-4.png" width="900"/>

---

## Step 3: Install and Configure Active Directory

**Instruction:** 

Install the Active Directory Domain Services role via Server Manager and promote the server to a domain controller.

```
Deployment Type: Add a new forest
Root Domain Name: Custom (e.g., `mydomain.com`)
Configure a DSRM password 
```

After reboot, confirm the domain by logging in.

**Objective:**

Active Directory Domain Services (AD DS) uses a _domain_ or centrally managed network for users, permissions, and devices. The server will be promoted to a **domain controller (DC)** since it is hosting the services making it responsible for logins and access permissions on the network. 

<img src="Step-Images/step3-0.png" width="900"/>
<img src="Step-Images/step3-1.png" width="900"/>
<img src="Step-Images/step3-2.png" width="900"/>
<img src="Step-Images/step3-3.png" width="900"/>

---

## Step 4: Create an Admin Account

**Instruction:** 

Create a separate admin account through AD Users and Computers: 

- Create an Organizational Unit (OU)
- Create a new user within the OU
- Add the user to the **Domain Admins** group

Navigation Path:

`Server Manager > Tools > Active Directory Users and Computers`

**Objective:**

To follow security best practices an admin user account is created. This safeguards the default administrator account and allows for better accountability of actions by keeping track of the specified user. 

<img src="Step-Images/step4-1.png" width="900"/>
<img src="Step-Images/step4-2.png" width="900"/>
<img src="Step-Images/step4-4.png" width="900"/>
<img src="Step-Images/step4-6.png" width="900"/>

---

## Step 5: Configure NAT and Routing

**Instruction:** 

Install the **Remote Access** role with the **Routing** service enabled through the Server Manager. Configure NAT to allow internal clients to reach external networks.

- Enable Routing and Remote Access
- Select the NAT option
- Assign the public (NAT) interface
- Close Routing and Remote Access window and repeat if internet adapters are not shown.

**Objective:**

This step allows internal devices to access the internet through the server. It simulates how organizations protect internal networks while still enabling external connectivity. The server acts as a gateway for network traffic.

<img src="Step-Images/step5-0.png" width="900"/>
<img src="Step-Images/step5-1.png" width="900"/>
<img src="Step-Images/step5-2.png" width="900"/>
<img src="Step-Images/step5-3.png" width="900"/>
<img src="Step-Images/step5-4.png" width="900"/>
<img src="Step-Images/step5-6.png" width="900"/>

---

## Step 6: Configure DHCP

**Instruction:** 

Install the DHCP Server role and configure a scope for internal clients:

- Create a new scope.
- Give an IP address range. 
- Add the domain controller's IP address as the default gateway.
- Activate the scope and authorize the server. 

Navigation Path:

`Server Manager > Tools > DHCP > IPv4 > New Scope...`

Example scope configuration:

```
Range: 172.16.0.100 – 172.16.0.200
Subnet Mask: 255.255.255.0
Default Gateway: 172.16.0.1
```

**Objective:**

Dynamic Host Configuration Protocol (DHCP) is a service that allows computers joining the domain to be automatically assigned IP address information, removing the need for a user to manually configure the setting. The connected devices are given an IP address from a predetermined range for the internal network to simplify management and reduce errors. 

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

**Instruction:** 

Users can be created manually through AD Users and Computers or the process can be automated through scripts using PowerShell. 

The provided PowerShell script:
- Reads names from a `names.txt` file via optional Python script
- Generates standardized usernames
- Detects and resolves duplicates
- Creates users in a specified OU

Navigation Path: 

`Start > Windows PowerShell > Windows PowerShell ISE > More > Run as administrator`

To run the script in the command line enter:

```
Set-ExecutionPolicy Unrestricted
```

**Objective:**
 
The use of PowerShell and Python allows for repetitive task such as creating users to be automated. This is more efficient and is less prone to mistakes. 

<img src="Step-Images/step7-0.png" width="900"/>
<img src="Step-Images/step7-1.png" width="900"/>
<img src="Step-Images/step7-2.png" width="900"/>

---

## Step 8: Create a Windows 11 Client VM

**Instruction:** 

Create a Windows 11 Pro VM using the Windows 11 ISO. Configure the VM with a single **Internal Network** adapter and set it to disabled.

During setup:
- Bypass Microsoft account creation using `SHIFT+F10 > CMD > OOBE\BYPASSNRO`
- Complete setup with a local account
- Enable the internal adapter after reaching the desktop

**Objective:**

This step simulates an employee workstation connecting to the network. The client relies on the server for authentication and network services.

<img src="Step-Images/step8-0.png" width="900"/>
<img src="Step-Images/step8-1.png" width="900"/>

---

## Step 9: Join the Client to the Domain

**Instruction:** 

Join the Windows 11 client to the domain using domain credentials and restart when prompted.

Navigation Path:

`Settings > System > About > Advanced system settings > Computer Name > Change`

**Objective:**

This step connects the client computer to the domain. Users can log in using domain credentials instead of local accounts.

<img src="Step-Images/step9-0.png" width="900"/>
<img src="Step-Images/step9-1.png" width="900"/>

---

## Step 10: Conclusion

**Instruction:** 

After joining the domain, sign in using a domain user account. Verify:

- Internet access (e.g., `ping google.com`)
- DHCP lease assignment on the domain controller

**Objective:**

This concludes the Active Directory home lab, demonstrating core Windows Server administration and automation concepts in a controlled environment. This final step confirms that all services are working together correctly. Successful login and network access verify that the environment is functioning as intended.

<img src="Step-Images/step9-2.png" width="900"/>
<img src="Step-Images/step9-3.png" width="900"/>
