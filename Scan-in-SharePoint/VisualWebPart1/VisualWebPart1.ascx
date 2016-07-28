<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VisualWebPart1.ascx.cs" Inherits="Scan_in_SharePoint.VisualWebPart1.VisualWebPart1" %>

<!DOCTYPE html>
<html>
<head>
    <title>Use Dynamic Web TWAIN to Upload</title>
    <script type="text/javascript" src="../_layouts/15/Resources/dynamsoft.webtwain.initiate.js"></script>
    <script type="text/javascript" src="../_layouts/15/Resources/dynamsoft.webtwain.config.js"></script>

</head>
<body>
    <h1>Scan and Upload Documents</h1>
    <select id="source"></select>
    <input type="button" value="Scan" onclick="AcquireImage();" />
    <input type="button" value="Open a local file" onclick="LoadImages();" />
    <input type="button" value="Upload" onclick="UploadImage();" /><br />
    <div id="dwtcontrolContainer"></div>

    <script type="text/javascript">
        Dynamsoft.WebTwainEnv.RegisterEvent('OnWebTwainReady', Dynamsoft_OnReady); // Register OnWebTwainReady event. This event fires as soon as Dynamic Web TWAIN is initialized and ready to be used

        var DWObject;

        function Dynamsoft_OnReady() {
            DWObject = Dynamsoft.WebTwainEnv.GetWebTwain('dwtcontrolContainer'); // Get the Dynamic Web TWAIN object that is embeded in the div with id 'dwtcontrolContainer'
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

        function LoadImages() {
            if (DWObject) {
                DWObject.IfShowFileDialog = true; // Open the system's file dialog to load image
                DWObject.LoadImageEx("", EnumDWT_ImageType.IT_ALL, OnSuccess, OnFailure); // Load images in all supported formats (.bmp, .jpg, .tif, .png, .pdf). OnSuccess or OnFailure will be called after the operation
            }
        }

        // OnHttpUploadSuccess and OnHttpUploadFailure are callback functions.
        // OnHttpUploadSuccess is the callback function for successful uploads while OnHttpUploadFailure is for failed ones.
        function OnHttpUploadSuccess() {
            location.reload();
        }

        function OnHttpUploadFailure(errorCode, errorString, sHttpResponse) {
            alert(sHttpResponse);
        }

        function UploadImage() {
            if (DWObject) {
                // If no image in buffer, return the function
                if (DWObject.HowManyImagesInBuffer == 0)
                    return;
                var strHTTPServer = location.hostname;
                DWObject.IfSSL = false; // Set whether SSL is used
                DWObject.HTTPPort = location.port == "" ? 80 : location.port;
                var Digital = new Date();
                var uploadfilename = Digital.getMilliseconds(); // Uses milliseconds according to local time as the file name
                DWObject.HTTPUploadAllThroughPutAsPDF(strHTTPServer, "/Document%20Library/" + uploadfilename + ".pdf", OnHttpUploadSuccess, OnHttpUploadFailure);
            }
        }
    </script>
</body>
</html>
