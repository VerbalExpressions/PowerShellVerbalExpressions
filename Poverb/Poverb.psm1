#Set-StrictMode -Version Latest
#$DebugPreference = "Continue"
 
###Create the terenary operator
# ---------------------------------------------------------------------------
# Name:   Invoke-Ternary
# Alias:  ?:
# Author: Karl Prosser
# Desc:   Similar to the C# ? : operator e.g.
#            _name = (value != null) ? String.Empty : value;
# Usage:  1..10 | ?: {$_ -gt 5} {"Greater than 5;$_} {"Not greater than 5";$_}
# ---------------------------------------------------------------------------
set-alias ?: Invoke-Ternary -Option AllScope -Description "PSCX filter alias"
filter Invoke-Ternary ([scriptblock]$decider, [scriptblock]$ifTrue, [scriptblock]$ifFalse)
{
   if (&$decider) {
      &$ifTrue
   } else {
      &$ifFalse
   }
}
###
 
###Region:Private variables
###
[String]$SCRIPT:source      = ""
[String]$SCRIPT:suffixes    = ""
[String]$SCRIPT:prefixes    = ""
$regexoptions              = [System.Text.RegularExpressions.RegexOptions]::Multiline
 
Set-Variable -Name source -Visibility Private
Set-Variable -Name prefixes -Visibility Private
Set-Variable -Name suffixes -Visibility Private
###End-Region:Private variables
###
 
###pre-defined method blocks
###
 
Function Get-RegexFromVerbex
{
        [CmdletBinding()]
              param(
                     [Parameter(Position=0,Mandatory=$True)]
                     [ScriptBlock]$verbex
              )
              BEGIN
              {
                     $SCRIPT:source      = ""
                     $SCRIPT:suffixes    = ""
                     $SCRIPT:prefixes    = ""
              }
              PROCESS
              {
                     #Write-Verbose @PSBoundParameters
                     & $verbex
                     Write-Verbose "`nPrefixes: '$SCRIPT:prefixes' `nSource: '$SCRIPT:source' `nSuffixes: '$SCRIPT:suffixes'"
                    
                     return ("'" + $SCRIPT:prefixes + $SCRIPT:source + $SCRIPT:suffixes + "'")
                    
              }
              END
              {
                     $SCRIPT:source      = ""
                     $SCRIPT:suffixes    = ""
                     $SCRIPT:prefixes    = ""
              }
}     
 
function add
{
       <#
              .SYNOPSIS
                 Append a transformed value to internal expression that will be compiled.
       #>
       [CmdletBinding()]
       param( [Parameter(Mandatory=$True)][String]$value,
                             [Bool]$sanitize = $True)
      
       $SCRIPT:source += $(?: {$sanitize} {[Regex]::Escape($value)} {$value})
      
}
 
 
function startofline
{
       [CmdletBinding()]
       param([Bool]$enable=$True)
       $SCRIPT:prefixes = $(?: {$enable} {"^"} {""})
      
}
 
function endofline
{
       [CmdletBinding()]
       param([Bool]$enable=$True)
       $SCRIPT:suffixes = $(?: {$enable} {"$"} {""})
      
}
 
function then
{
       [CmdletBinding()]
       param(
              [Parameter(Mandatory=$True)][String]$value,
        [Bool]$sanitize = $True
       )
    $sanitizedvalue = ?: {$sanitize} {[Regex]::Escape($value)} {$value}
    $value = [String]::Format("(?:{0})", $sanitizedvalue)
    add $value $false
}
 
function find
{
       [CmdletBinding()]
       param([Parameter(Mandatory=$True)] [String]$value)
       then $value
}
 
function maybe
{
       [CmdletBinding()]
       param(
              [Parameter(Mandatory=$True)][String]$value,
        [Bool]$sanitize = $True
       )
$value = ?: {$sanitize} {[Regex]::Escape($value)} {$value}
$value = [String]::Format("(?:{0})?", $value)
add $value $false
 
}
 
function anythingbut
{
       [CmdletBinding()]
    param(  [Parameter(Mandatory=$True)][String]$value,
            [Bool]$sanitize = $True
       )
    $value = ?: {$sanitize} {[Regex]::Escape($value)} {$value}
    $value = [String]::Format("(?:[^{0}]*)", $value)
    add $value  $false
}
 
function anyof
{
       [CmdletBinding()]
       param(  [Parameter(Mandatory=$True)][String]$value,
            [Bool]$sanitize = $True
    )
    $value = ?: {$sanitize} {[Regex]::Escape($value)} {$value}
    $value = [String]::Format("(?:[{0}])", [Regex]::Escape($value))
    add $value $false
}
 
function any
{
       [CmdletBinding()]
       param([Parameter(Mandatory=$True)][String]$value)
       anyof $value
}
 
function anything
{
       add "(?:.*)" $false
}
 
function linebreak
{
       add "(?:(?:\n)|(?:\r\n))" $false
}
 
function br
{
       linebreak
}
 
function tab
{
       add "\t"
}
 
function word
{
       add "\w+" $false
}
 
Export-ModuleMember -function "Get-RegexFromVerbex", "any", "anyof", "anything", "anythingbut", "br", "endofline", "find", "linebreak", "maybe", "replacer", "startofline", "tab", "then", "word"