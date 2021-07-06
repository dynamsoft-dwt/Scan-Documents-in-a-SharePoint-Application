<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="VB" AutoEventWireup="true" CodeBehind="VisualWebPart1.ascx.vb" Inherits="ScanDocument_SharePoint.VisualWebPart1" %>


<!DOCTYPE html>
<html>
<head>
    <title>Use Dynamic Web TWAIN to Upload</title>
    <script src="https://unpkg.com/dwt/dist/dynamsoft.webtwain.min.js"> </script>   
</head>
<body>
    <select size="1" id="source" style="position: relative; width: 220px;"></select>
    <input type="button" value="Scan" onclick="AcquireImage();" />
    <input type="button" value="Load" onclick="LoadImage();" /><br />
    Extra Info:
    <input type="text" id="infoToSend" value="I feel good today!" />
    <input type="button" value="Upload" onclick="UploadImage();" />

    <!-- dwtcontrolContainer is the default div id for Dynamic Web TWAIN control.
    If you need to rename the id, you should also change the id in the dynamsoft.webtwain.config.js accordingly. -->
    <div id="dwtcontrolContainer"></div>

    <script type="text/javascript">
        var DWObject;

        window.onload = function () {
            Dynamsoft.DWT.AutoLoad = false;
            Dynamsoft.DWT.Containers = [{ ContainerId: 'dwtcontrolContainer', Width: '100%', Height: '500px' }];
            Dynamsoft.DWT.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady);
			
			/** v17.1 LICENSE ALERT - README
			 * The library requires a license to work, the APIs organizationID and handshakeCode specify how to acquire a license.
			 * If nothing is specified, a 7-day (public) trial license will be used by default which is the case in this sample.
			 * Note that network connection is required for this license to work.
			 */

			/* When using your own license, please uncomment the following lines and fill in your own information. */
			/* To get a free trial, please visit https://www.dynamsoft.com/customer/license/trialLicense?product=dwt. */

			// Dynamsoft.DWT.organizationID = "YOUR-ORGANIZATION-ID";
			// Dynamsoft.DWT.handshakeCode = "A-SPECIFIC-HANDSHAKECODE";
			// Dynamsoft.DWT.sessionPassword = "PASSWORD-TO-PROTECT-YOUR-LICENSE"; // Important field to protect your license.
			// Dynamsoft.DWT.licenseServer = ["YOUR-OWN-MAIN-LTS", "YOUR-OWN-STANDBY-LTS"]; // Ignore this line if you are using Dynamsoft-hosting LTS

			/* The API "ProductKey" is an alternative way to license the library, the major difference is that it does not require a network. Contact support@dynamsoft.com for more information. */

			// Dynamsoft.DWT.ProductKey = "YOUR-PRODUCT-KEY";

			/** LICENSE ALERT - THE END */
	
			ynamsoft.DWT.ResourcesPath = 'https://unpkg.com/dwt/dist/';

            Dynamsoft.DWT.Load();
        };

        function Dynamsoft_OnReady() {
            DWObject = Dynamsoft.DWT.GetWebTwain('dwtcontrolContainer'); // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
            if (DWObject) {
                var count = DWObject.SourceCount; // Populate how many sources are installed in the system
                for (var i = 0; i < count; i++)
                    document.getElementById("source").options.add(new Option(DWObject.GetSourceNameItems(i), i));  // Add the sources in a drop-down list
            }
        }

        function AcquireImage() {
            if (DWObject) {
                DWObject.SelectSourceByIndex(document.getElementById("source").selectedIndex);
                DWObject.OpenSource();
                DWObject.IfDisableSourceAfterAcquire = true;	// Scanner source will be disabled/closed automatically after the scan.
                DWObject.AcquireImage();
            }
        }

        //Callback functions for async APIs
        function OnSuccess() {
            console.log('successful');
        }

        function OnFailure(errorCode, errorString) {
            alert(errorString);
        }

        function LoadImage() {
            if (DWObject) {
                DWObject.IfShowFileDialog = true; // Open the system's file dialog to load image
                DWObject.LoadImageEx("", Dynamsoft.DWT.EnumDWT_ImageType.IT_ALL, OnSuccess, OnFailure); // Load images in all supported formats (.bmp, .jpg, .tif, .png, .pdf). OnSuccess or OnFailure will be called after the operation
            }
        }

        // OnHttpUploadSuccess and OnHttpUploadFailure are callback functions.
        // OnHttpUploadSuccess is the callback function for successful uploads while OnHttpUploadFailure is for failed ones.
        function OnHttpUploadSuccess() {
            console.log('successful');
        }

        function OnHttpUploadFailure(errorCode, errorString, sHttpResponse) {
            alert(sHttpResponse);
        }

        function UploadImage() {
            if (DWObject) {
                // If no image in buffer, return the function
                if (DWObject.HowManyImagesInBuffer == 0)
                    return;

                var strHTTPServer = location.hostname; //The name of the HTTP server. For example: "www.dynamsoft.com";
                var CurrentPathName = unescape(location.pathname);
                var CurrentPath = CurrentPathName.substring(0, CurrentPathName.lastIndexOf("/") + 1);
                //var strActionPage = CurrentPath + "SaveFileWithUploadedInfo.aspx";

                var strActionPage = "/_layouts/15/SaveFileWithUploadedInfo.aspx";
                DWObject.IfSSL = false; // Set whether SSL is used
                DWObject.HTTPPort = location.port == "" ? 80 : location.port;

                var Digital = new Date();
                var uploadfilename = Digital.getMilliseconds(); // Uses milliseconds according to local time as the file name

                // Set extra info as HTTP form fields to be sent to the server together with the images
                DWObject.ClearAllHTTPFormField();
                DWObject.SetHTTPFormField('extraInfo', document.getElementById("infoToSend").value);
                // Upload the image(s) to the server asynchronously
                DWObject.HTTPUploadAllThroughPostAsPDF(strHTTPServer, strActionPage, uploadfilename + ".pdf", OnHttpUploadSuccess, OnHttpUploadFailure);
            }
        }
    </script>
</body>
</html>