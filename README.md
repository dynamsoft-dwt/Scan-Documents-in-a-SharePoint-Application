# Scan-Documents-in-a-SharePoint-Application

This sample demonstrates how to integrate Dynamic Web TWAIN in a web part of SharePoint.

####
Dynamsoft Team
2016-07-28

#### Instructions

In order to run the sample, you need to

1. Install Dynamic Web TWAIN on a PC running Windows
2. The /Resources/ folder and all the files inside are the files required on the server side for Dynamic Web TWAIN. 
We’ll upload them to the SharePoint layouts folder so that they can be accessed through the SharePoint server. 
Find your SharePoint LAYOUTS folder. Typically, this is located at: 
C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\TEMPLATE\LAYOUTS
Copy the previously mentioned /Resources/ folder and all the files here.
3. In the file dynamsoft.webtwain.config, change the following line like this

Dynamsoft.WebTwainEnv.ResourcesPath = '_layouts/Resources';

4. Attach the web part in the sample to your sharepoint application

#### Complete Sample
In order to test the sample on your own, you need to download the complete code from [here](http://www.dynamsoft.com/Samples/DWT/Scan-Documents-in-a-SharePoint-Application.zip).

#### NOTE
This sample by default uploads documents as PDFs to the default 'Document Library'.

####Reference
* Core Software used: [Dynamic Web TWAIN](https://www.dynamsoft.com/CustomerPortal/LoginOrRegister.aspx?status=signup&op=4DD608F3803493E4&product=CB4BDC4FF903450C)
* APIs used in the sample: [Dynamic Web TWAIN APIs] (http://developer.dynamsoft.com/dwt/acquireimage).

Should you need any technical help, please write to 
support@dynamsoft.com.

Thanks.



