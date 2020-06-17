# oci-owl-analytics

This is a Terraform module that deploys [OwlDQ](https://owl-analytics.com/) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  It is developed jointly by Oracle and Owl Analytics.

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

## Clone the Module
You'll first want a local copy of this repo by running:

```
git clone https://github.com/oracle-quickstart/oci-owl-analytics.git
cd oci-owl-analytics/
```
We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

```
terraform init
```
This gives the following output:

```
Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "oci" (hashicorp/oci) 3.80.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

## Deploy

First we want to run `terraform plan`. This runs through the terraform and lists
out the resources to be created based on the values in `variables.tf`. If the
variable doesn't have a default you'll be prompted for a value. Currently the
only variable that doesn't have a default is `var.key`, this is the OwlDQ product
key.

If that's good, we can go ahead and apply the deploy:

```
terraform apply
```

You'll need to enter `yes` when prompted.  The apply should take several minutes
to run, and the final setup will happen asynchronously after this returns.

Once complete, you'll see something like this:

```
oci_core_instance.owl-vm: Still creating... [50s elapsed]
oci_core_instance.owl-vm: Still creating... [1m0s elapsed]
oci_core_instance.owl-vm: Still creating... [1m10s elapsed]
oci_core_instance.owl-vm: Creation complete after 1m17s [id=ocid1.instance.oc1.iad.anuwcljrugt6wmqczib34tr4vfuxnekxkssz7esctjwkv7faxxqrgxbkoo4a]

Apply complete! Resources: 1 added, 1 changed, 1 destroyed.

Outputs:

instance_https_url = https://193.122.164.142
instance_id = ocid1.instance.oc1.iad.anuwcljrugt6wmqczib34tr4vfuxnekxkssz7esctjwkv7faxxqrgxbkoo4a
instance_private_ip = 10.0.0.3
instance_public_ip = 193.122.164.142
nsg_id = ocid1.networksecuritygroup.oc1.iad.aaaaaaaa4jscbnm5aimhmyexz36k33yiiapqr7hj6gdarfn3s73z24jzxbaq
subnet_id = ocid1.subnet.oc1.iad.aaaaaaaae4j6ydltdj65iw5wazuoumdk3pdrmnbawe2gt6dqlrunerbegnva
subscription = []
vcn_cidr_block = 10.0.0.0/16
vcn_id = ocid1.vcn.oc1.iad.amaaaaaaugt6wmqabexrgxhkhq4nr5wyktj3o7mrjnzurjlkcx3lnspqegwa
Collins-MacBook-Pro:oci-owl-analytics jpoczate$ terraform destroy

```

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

```
terraform destroy
```

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

```
oci_core_subnet.public_subnet[0]: Destruction complete after 1s
oci_core_network_security_group.nsg: Destruction complete after 2s
oci_core_vcn.vcn[0]: Destroying... [id=ocid1.vcn.oc1.iad.amaaaaaaugt6wmqakwyeb5ngeabevc6qs4oavtdtxnzq4fov3xktdobg7viq]
oci_core_vcn.vcn[0]: Destruction complete after 0s

Destroy complete! Resources: 20 destroyed.
```

All resources created by this deployment have now been destroyed.
