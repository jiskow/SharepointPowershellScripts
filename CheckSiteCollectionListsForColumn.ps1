#Add DLLs
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.Sharepoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.Sharepoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.Sharepoint.Taxonomy.dll"

#Variables
$username ="jon.iskow@am.jll.com"
$password = ConvertTo-SecureString 'Perficient1' -AsPlainText -Force
$url= "https://jll2.sharepoint.com"
$fieldName="Document Category" 

#Get the Context 
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$credentials= New-Object Microsoft.Sharepoint.Client.SharePointOnlineCredentials ($username, $password) 
$clientContext.Credentials=$credentials

$site = $clientContext.Site
$rootWeb = $site.RootWeb
$clientContext.Load($site)
$clientContext.Load($rootWeb)
$clientContext.Load($rootWeb.Lists)
$clientContext.ExecuteQuery()


#Check lists for field
function checkLists {
param(
[parameter(ValueFromPipeline=$true)] [Microsoft.Sharepoint.Client.Web] $web
) 
    $clientContext.Load($web.Lists)
    $clientContext.ExecuteQuery()
    foreach($list in $web.Lists)
    {
        $clientContext.Load($list.Fields)
        $clientContext.ExecuteQuery()
        foreach($field in $list.Fields)
        {
            if($field.Title -eq $fieldName)
            {
                    $info =New-Object PSObject -Property @{
                        WebUrl=$web.Url
                        ListTitle=$list.Title
                    }
                    Write-output $info
            }
        } 
    }

}

#Check web 
function checkWeb {
param(
[parameter(ValueFromPipeline=$true)] [Microsoft.Sharepoint.Client.Web] $web
) 
    $clientContext.Load($rootWeb.Webs)
    $clientContext.ExecuteQuery()
    
    foreach($web in $rootWeb.Webs)
    {
     checkLists($web)   
        $clientContext.Load($web.Lists)
        $clientContext.ExecuteQuery()
        foreach($list in $web.Lists)
        {
            $clientContext.Load($list.Fields)
            $clientContext.ExecuteQuery()
            foreach($field in $list.Fields)
            {
                if($field.Title -eq $fieldName)
                {
                    $info =New-Object PSObject -Property @{
                        WebUrl=$web.Url
                        ListTitle=$list.Title
                    }
                    Write-output $info
                }
            } 
        }
    }

}

checkWeb($rootWeb) | OUt-File $PSScriptRoot/columns2.txt  