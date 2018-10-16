download inspec from https://downloads.chef.io/inspec

try inspec https://learn.chef.io/modules/try-inspec#/

https://github.com/inspec/inspec-azure

To allow InSpec to authenticate to your Azure account you will need to [create an Azure service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?toc=%2Fen-us%2Fazure%2Fazure-resource-manager%2Ftoc.json&bc=%2Fen-us%2Fazure%2Fbread%2Ftoc.json&view=azure-cli-latest).

Make sure you take not of the newly generated access key and create an Azure credentials file in ./azure/credentials

The credentials file should have the following structure:

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
Therefor, extend your profile to be dependant on `inspec-azure` resource pack:

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

Besides the profile you will need a control which defines what InSpec is going to test in your subscription. Create a new file 'exists_resourcegroup.rb' in the controls folder within your profile.
Add the following content to the file to check if a given resource group exists.

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
