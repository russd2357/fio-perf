aksprefix                = "aks"
storageaccountnameprefix = "dasa"
nfs_share_enabled        = true
##################################################
## 01 Remote Storage State configuration
##################################################

# Deployment state storage information
tf_state_rg_name        = "dapolinatfstate"
tf_state_sa_name        = "dapolinatfstate" 
tf_state_container_name = "tfstatecontainer"
tf_state_key            = "terraform.tfstate"