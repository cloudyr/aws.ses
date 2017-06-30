# AWS SES Client Package

**aws.ses** is a simple client package for the Amazon Web Services (AWS) [Simple Email Service (SES)](http://aws.amazon.com/ses/) API, which can be used to send email messages.

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

By default, all **cloudyr** packages for AWS services allow the use of credentials specified in a number of ways, beginning with:

 1. User-supplied values passed directly to functions.
 2. Environment variables, which can alternatively be set on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). Or they can be set within R:
 
    ```R
    Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
               "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
               "AWS_DEFAULT_REGION" = "us-east-1",
               "AWS_SESSION_TOKEN" = "mytoken")
    ```
 3. If R is running an EC2 instance, the role profile credentials provided by [**aws.ec2metadata**](https://cran.r-project.org/package=aws.ec2metadata).
 4. Profiles saved in a `/.aws/credentials` "dot file" in the current working directory. The `"default" profile is assumed if none is specified.
 5. [A centralized `~/.aws/credentials` file](https://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs), containing credentials for multiple accounts. The `"default" profile is assumed if none is specified.

Profiles stored locally or in a centralized location (e.g., `~/.aws/credentials`) can also be invoked via:

```R
# use your 'default' account credentials
aws.signature::use_credentials()

# use an alternative credentials profile
aws.signature::use_credentials(profile = "bob")
```

Temporary session tokens are stored in environment variable `AWS_SESSION_TOKEN` (and will be stored there by the `use_credentials()` function). The [aws.iam package](https://github.com/cloudyr/aws.iam/) provides an R interface to IAM roles and the generation of temporary session tokens via the security token service (STS).


## Code Examples

The package does not yet support all SES functionality, but does provide the basic mechanisms for verifying a sender email address (i.e., your email) and sending messages once that sender address has been verified.

```R
# setup/verify email address
verify_identity("me@example.com")

# check verification status
get_verification_attrs("me@example.com")

# send an email
## simple plain-text email
send_email("Test Email Body", subject = "Test Email", 
           from = "me@example.com", to = "recipient@example.com")

# html and plain text versions
send_email(message = "Plain text body", html = "<div><p style='font-weight=bold;'>HTML text body</p></div>", 
           subject = "Test Email", 
           from = "me@example.com", to = "recipient@example.com")
```

Messages can be sent to up to 50 recipients, using any combination of To, CC, and BCC forms.

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.ses)](https://cran.r-project.org/package=aws.ses)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.ses)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.ses.png?branch=master)](https://travis-ci.org/cloudyr/aws.ses)
[![codecov.io](https://codecov.io/github/cloudyr/aws.ses/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.ses?branch=master)

This package is not yet on CRAN. To install the latest development version you can install from the cloudyr drat repository:

```R
# latest stable version
install.packages("aws.ses", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))
```

Or, to pull a potentially unstable version directly from GitHub:

```R
if (!require("ghit")) {
    install.packages("ghit")
}
ghit::install_github("cloudyr/aws.ses")
```


---
[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
