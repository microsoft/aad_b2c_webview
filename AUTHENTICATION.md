Setting Up User Flows in Azure AD B2C: Sign Up & Sign In With Custom UI Implementation
============================

## Getting started
Azure Active Directory B2C (AAD B2C) is a cloud-based identity and access management service that enables you to customize and control the user sign-up, sign-in, and profile management process. In this document, we'll walk through the process of setting up user flows in AAD B2C, including creating custom login pages using HTML and CSS.

First, you'll need to create an Azure AD B2C tenant if you don't already have one. You can do this by visiting the Azure portal and selecting "Create a resource" and then searching for "Azure AD B2C". Once your tenant is set up, you'll need to create a user flow.

User flows define the sign-up and sign-in experiences for your users. AAD B2C includes several built-in user flows, such as "Sign up or sign in" and "Profile editing", but you can also create custom user flows. To create a new user flow, navigate to the "User flows (policies)" section of the AAD B2C tenant in the Azure portal and select "New user flow".

Next, you'll need to customize the user flow. AAD B2C provides a built-in designer that allows you to add and remove steps, customize the user interface, and add custom HTML and CSS. For example, you can create a custom login page using HTML and CSS and add it to the user flow.

To enable custom HTML and CSS, you need to enable "Advanced customization" in the user flow. This will allow you to upload custom HTML and CSS files to be used in the user flow.

Navigate to Page Layouts and select "Custom HTML" to upload your custom HTML file. The HTML file preferably should be hosted in a blob container with anonymous read access enabled. You can also upload the HTML file to the AAD B2C tenant and use the URL to the file.

Once you have finished customizing the user flow, you can test it by using the "Run user flow" button in the Azure portal. Once you are satisfied with the results, you can publish the user flow and start using it in your application.

It is important to note that the custom HTML and CSS files should be hosted on a secure server. Also, Make sure to review the Azure AD B2C documentation before starting and also check the Azure AD B2C Pricing page to understand the costs associated with using this service.

## Steps to create a custom login page using HTML and CSS

### Step 1: Create a new user flow
* Create a new user flow by navigating to the "User flows (policies)" section of the AAD B2C tenant in the Azure portal and selecting "New user flow".
* Select "Sign up or sign in (recommended)". This will create a new user flow with a sign-in step and a sign-up step.
* Give the user flow a name , select conditional access policies ,whether you need an email/phone signup, select claims and click "Create".

### Step 2: Enable advanced customization
* Navigate to the "User flows (policies)" section of the AAD B2C tenant in the Azure portal and select the user flow you created in the previous step.
* Select "Advanced customization" or "Page Layouts" and upload custom HTML and CSS files for each step of user flow.
* Select "Save" to save the changes.
* Navigate to the properties and enable Javascript and click "Save".

## Links for reference:
[Azure AD B2C documentation](https://docs.microsoft.com/en-us/azure/active-directory-b2c/)
[Azure AD B2C Pricing](https://azure.com/pricing/details/active-directory-b2c/)