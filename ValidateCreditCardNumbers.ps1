#inputs stored in variable
$CC = Get-Content sampleinput.txt

#removing the N variable from inputs
$content = $CC | select -Skip 1

#piping list to a loop to verify data
$content | foreach {
      
    #4 consecutive digit validation variable
    $consecVal = $null
    #last character in array tracker
    $prevChar = $null
    #consecutive character counter
    $instanceCount = 1
    #looping throught string to find consecutives
    $_.ToCharArray() | foreach {

        if ( $_ -eq $prevChar ) {
            ++$instanceCount
        }
        #hyphens are accounted for here
        elseif ( $_ -ne $prevChar -and $_ -ne "-" ) {
            $prevChar = $_
        }

        elseif ( $instanceCount -gt 3 ) {

            $consecVal = "invalid"
        }

    }

    #print invalid if consecutives found in the above function
    if ( $consecVal -eq "invalid" ) {

        Write-Host Invalid
    }
   
    #print invalid if not a length of 16 or 19
    elseif ( 16 -ne $_.length -and 19 -ne $_.length ) {

        Write-Host Invalid
    }

    #print invalid if does not start with 4, 5, or 6
    elseif ( "4" -ne $_[0] -and "5" -ne $_[0] -and "6" -ne $_[0] ) {

        Write-Host Invalid

    }
   
    #print invalid if it does not match the allowed patterns
    elseif ( $_ -notmatch "\d\d\d\d-\d\d\d\d-\d\d\d\d-\d\d\d\d" -and $_ -notmatch "\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d") {

        Write-Host Invalid

    }
   
    #print valid once all other criteria are met
    else { Write-Host Valid }

}