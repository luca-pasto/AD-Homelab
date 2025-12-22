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

**Step 3: Install and Configure Active Directory Services**

From the Server Manager window select "Add roles and features" -> select the domain controller -> select "Active Directory Domain Services" and "Add Features" -> select Next until the Install button appears. Once the installation is complete a warning sign will appear to finish the initial configuration. Select "Promote this server to a domain controller" -> Deployment Configuration: "Add a new forest" -> enter a domain name -> set a DSRM password -> Next until Install which will prompt a restart. This is done correctly when the next sign-in shows "MYDOMAIN\Administrator". 

<img src="Step-Images/step3-0.png" width="900"/>
<img src="Step-Images/step3-1.png" width="900"/>
<img src="Step-Images/step3-2.png" width="900"/>
<img src="Step-Images/step3-3.png" width="900"/>

**Step 4: Create an Admin Account**

From the Server Manager select Tools -> Active Directory Users and Computers -> right-click "mydomain.com" -> New -> Organizational Unit. Name the OU then uncheck the box for accidental deletion. While the OU folder is selected "Create a new user in the current container." -> enter a name and user logon name -> set a password and select never expire. This will then show a summary of the account where you can select "Finish". Next, right-click the account and select Properties -> Member Of -> Add... -> in "Select Groups" under the "Enter the object names to select" box enter "domain admins" and click "Check Names" -> "OK" -> "Apply". Now that the admin account has been created, sign-in using the new credentials. 

<img src="Step-Images/step4-0.png" width="900"/>
<img src="Step-Images/step4-1.png" width="900"/>
<img src="Step-Images/step4-2.png" width="900"/>
<img src="Step-Images/step4-3.png" width="900"/>
<img src="Step-Images/step4-4.png" width="900"/>
<img src="Step-Images/step4-6.png" width="900"/>

**Step 5: Configure NAT/RAS**

From Server Manager select Add Roles and Features -> select the desired domain controller -> in "Select server roles" check "Remote Access" -> click next until "Select role services" -> check the box for "Routing" and click "Add Features" in the new window -> next until Install option is available. Next go to "Tools" and select "Routing and Remote Access" -> right-click the domain controller and select "Configure and Enable..." -> select Network address translation (NAT) -> select "Use this public interface to connect to the internet" and make sure to select the home internet NIC to finish the configuration. A common issue is that the box will be blank, just close the window and retry the steps again or restart the VM. 

<img src="Step-Images/step5-0.png" width="900"/>
<img src="Step-Images/step5-1.png" width="900"/>
<img src="Step-Images/step5-2.png" width="900"/>
<img src="Step-Images/step5-3.png" width="900"/>
<img src="Step-Images/step5-4.png" width="900"/>
<img src="Step-Images/step5-6.png" width="900"/>

**Step 6: Configure DHCP**

Use Server Manager to add the DHCP Server role and complete the installation using the default settings similar to the other services. Open the DHCP management console via Tools, expand IPv4, and create a new scope with a range of 172.16.0.100-200, using a subnet mask of 255.255.255.0 -> NEW SCOPE -> Name: 172.16.0.100-200 -> Start IP address: 172.16.0.100 -> End IP address: 172.16.0.200 -> Length: 24. Leave exclusions, delays, and lease duration at their default values, then configure DHCP options by setting the default gateway (router) to 172.16.0.1 and leaving WINS settings unchanged. Activate the scope, authorize the DHCP server in Active Directory, and refresh the console to confirm the service is running.

<img src="Step-Images/step6-0.png" width="900"/>
<img src="Step-Images/step6-1.png" width="900"/>
<img src="Step-Images/step6-2.png" width="900"/>
<img src="Step-Images/step6-3.png" width="900"/>
<img src="Step-Images/step6-4.png" width="900"/>
<img src="Step-Images/step6-5.png" width="900"/>
<img src="Step-Images/step6-6.png" width="900"/>
<img src="Step-Images/step6-7.png" width="900"/>

**Step 7: Create Users Manually or via PowerShell/Python Scripts**

Similar to creating an administrative account, standard user accounts can be created manually through Active Directory Users and Computers by creating an organizational unit, disabling accidental deletion, and using the New User wizard to assign usernames and passwords. For scalability, this can be done via a PowerShell script. This script automates Active Directory user creation by reading first and last names from a text file and generating standardized usernames. It formats usernames using the first letter of the first name and up to five characters of the last name, then checks Active Directory for existing accounts and appends a number if duplicates are found. The script creates an organizational unit if it does not already exist and provisions each user with a preset password, non-expiring credentials, and automatic placement into the designated OU. The text file can also be generated using Pyhton scripting. In the example shown below, Python was used to collect the names from all of the NBA rosters from the ESPN website. It then formats each name into a list for Active Directory use. 

To use the included PowerShell script from the desktop click on "Start" -> Windows PowerShell -> Windows PowerShell ISE -> right-click -> More -> "Run as administrator". Once it is open type "Set-Execution Policy Unrestricted" into the terminal and press enter. It will open a new window for the execution policy change -> select "Yes to All". The script can be used from the desktop with a names.txt file. 

<img src="Step-Images/step7-0.png" width="900"/>
<img src="Step-Images/step7-1.png" width="900"/>
<img src="Step-Images/step7-2.png" width="900"/>


