# snowtofu
Deploy Snowflake objects from Tofu (Open Source terraform) 


##
shell
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out snowflake_tf_snow_key.p8 -nocrypt
$ openssl rsa -in snowflake_tf_snow_key.p8 -pubout -out snowflake_tf_snow_key.pub


Copy the text contents of the ~/.ssh/snowflake_tf_snow_key.pub file, including the PUBLIC KEY header and the PUBLIC KEY footer.

sql
USE ROLE ACCOUNTADMIN;

CREATE USER TERRAFORM_SVC
    TYPE = SERVICE
    COMMENT = "Service user for Terraforming Snowflake"
    RSA_PUBLIC_KEY = "-----BEGIN PUBLIC KEY-----

-----END PUBLIC KEY-----";

GRANT ROLE SYSADMIN TO USER TERRAFORM_SVC;
GRANT ROLE SECURITYADMIN TO USER TERRAFORM_SVC;



Go to your GitHub repository.
Click on "Settings".
In the left sidebar, under "Security", click on "Secrets and variables", then "Actions".
Click on "New repository secret" for each of the secrets you need to create:
TF_VAR_ORGANIZATION_NAME: Your Snowflake organization name  
TF_VAR_ACCOUNT_NAME: Your Snowflake account name 
TF_VAR_PRIVATE_KEY_PATH: The path within the GitHub Actions runner where your private key file will be. Important: You will also need to securely store the content of your snowflake_tf_snow_key.p8 file as another secret, and then write it to this path in a workflow step before tofu init and tofu plan are run.
A common way to handle the private key file itself is to:

Create another secret, for example, SNOWFLAKE_PRIVATE_KEY, and paste the content of your snowflake_tf_snow_key.p8 file as its value.
In your GitHub Actions workflow, add a step before Tofu Init to write the content of this secret to the path specified by TF_VAR_PRIVATE_KEY_PATH.
Here's an example step to write the private key content to a file: