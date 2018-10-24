

Working with Infrastructure as Code brings some challanges. 


Chef Inspec helps you to test your infrastructure code once it is deployed in Azure.

Inspec can be downloaded for various operating systems from [Inspec website](https://downloads.chef.io/inspec). There is also a very nice online experience where you can [try Inpsec in your browser](https://learn.chef.io/modules/try-inspec#/)

Since Inspec is completely open source you might want to check on its source code with [can be found on Github](https://github.com/inspec/inspec-azure)

If you just want to try Inspec, instead of downloading and installing it manually, I recommend using Azure Cloud Shell. Azure Cloud Shell comes preinstalled with all the nifty tools like Git, Azure CLI and even Inspec.

#I recommend checking out this site for more information on Azure Cloud Shell

After you got your Cloud Shell ready or installed Inspec on your machine, you need to give it access to your Azure resources. To allow InSpec to authenticate to your Azure account you will need to [create an Azure service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?toc=%2Fen-us%2Fazure%2Fazure-resource-manager%2Ftoc.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json&view=azure-cli-latest).

Make sure you take note of the newly generated access key. Afterwards create an Azure credentials file in ./azure/credentials

This credentials file should have the following structure:

```powershell
[<SUBSCRIPTION_ID>]
client_id = "<APPLICATION_ID>"
client_secret = "<KEY>"
tenant_id = "<DIRECTORY_ID>"
```

Now your are ready to run InSpec against your Azure resources.

First of all create a new profile by executing the following command. This will create a new folder in your current directory which contains several new files.
```powershell
PS C:\learn-inspec> inspec init profile azure_profile
Create new profile at C:/learn-inspec/azure_profile
 * Create directory controls
 * Create file controls/example.rb
 * Create file inspec.yml
 * Create directory libraries
 * Create file README.md
 * Create file libraries/.gitkeep
```

## Remove example control!

Open the newly created inspec.xml file which is found in the profile directory and change default values to something meaningful

```ruby
name: azure_profile
title: Learning InSpec with Azure
maintainer: Stefan Johner
copyright: Stefan Johner
license: Apache-2.0
summary: An InSpec Compliance Profile for Azure resource groups
version: 0.1.0
```

InSpec Azure resources are available as resource pack and to use them in your controls, you will need to create an inspec profile which depends on the given Azure resource pack.
Therefore, extend your profile to be dependant on `inspec-azure` resource pack:

```ruby
name: azure_profile
title: Learning InSpec with Azure
maintainer: Stefan Johner
copyright: Stefan Johner
license: Apache-2.0
summary: An InSpec Compliance Profile for Azure resource groups
version: 0.1.0
inspec_version: '>= 2.2.7'
depends:
  - name: inspec-azure
    url: https://github.com/inspec/inspec-azure/archive/master.tar.gz
supports:
  - platform: azure
```

Besides the profile you will need an Inspec control which defines what InSpec is going to test in your subscription. Create a new file 'exists_resourcegroup.rb' in the controls folder within your profile.
Add the following content to the file to make sure the control checks if a given resource group exists.

```ruby
control 'exists_resourcegroup' do
    impact 1.0
    title "Resource Group exists"
    desc "A resource group jhnr-dev-rg-01 should exist."
    describe azurerm_resource_groups.where('name' => 'jhnr-dev-rg-01') do
        it { should exist }
    end
end
```

Now go and run a check to see if your profile is valid or if it has any errors or warnings.
 ```powershell
PS C:\learn-inspec> inspec check inspec check azure_profile
Location:    azure_profile
Profile:     azure_profile
Controls:    3
Timestamp:   2018-08-16T16:43:49+02:00
Valid:       true

No errors or warnings
```

Perfect! To run the checks against your Azure account, execute your InSpec profile with Azure as target provider.
```powershell
inspec exec my-inspec-profile -t azure://
