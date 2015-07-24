get-spsite https://sharepointdev.neu.edu | get-spweb -limit all | foreach-object {
    if(sitelogoURL="" -Or sitelogoURL="titlegraphic.gif"){ 
        $_.sitelogoURL = "/_layouts/images/NEU.SP2010.Branding/NEU-LOGO.png"; 
        $_.Update()
    }
    else
    {
    }
}
  