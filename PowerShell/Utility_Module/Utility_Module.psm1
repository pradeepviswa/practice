Function utilGet-WebPageTitle{
[CmdLetBinding()]
param(
[Parameter(mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
[String]$url
)
    # Specify the URL of the web page
    #$url = "https://www.youtube.com/"

    $retValue = $null
    try {
        # Send a web request and get the response with basic parsing
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing

        if ($response -and $response.Content) {
            # Extract the title using regex
            $titleMatch = [regex]::Match($response.Content, '<title>(.*?)</title>')

            if ($titleMatch.Success) {
                $title = $titleMatch.Groups[1].Value
                # Output the title
                $retValue = "The title of the web page is: $title"
            } else {
                $retValue = "No title found in the web page."
            }
        } else {
            $retValue = "Failed to retrieve the content from the URL."
        }
    } catch {
        $retValue = "An error occurred: $_"
    }

    Return $retValue

}#utilGet-WebPageTitle

utilGet-WebPageTitle