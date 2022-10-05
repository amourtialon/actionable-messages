param(
  [Parameter(Mandatory=$true)]
  $From,
  [Parameter(Mandatory=$true)]
  $To,
  [Parameter(Mandatory=$true)]
  $FullPathCard,
  [Parameter(Mandatory=$true)]
  $Subject
)

Connect-MgGraph -Scopes "Mail.Send"

$MailBody = (Get-Content .\MailBody.html)
$Card = (Get-Content $FullPathCard -Encoding utf8) | ConvertFrom-Json

$CardJson = $Card | ConvertTo-Json -Depth 7

$Message = $MailBody.Replace("%CARD%",$CardJson)

$Body = @{

    message = @{
        subject = "$Subject"
    
    body = @{
        contentType = "HTML"
        content     = "$Message"
    }
    toRecipients =  @(@{
        emailAddress = @{
            address = "$To"
        }}
    
    )
    }
}

Send-MgUserMail -UserId $To -BodyParameter $Body
