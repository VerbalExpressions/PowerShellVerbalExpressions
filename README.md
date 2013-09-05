PowerShellVerbalExpressions
===========================

PowerShell regular expression made easy using Verbal expressions.  
 
**Note:**This is currently a partial implementation only.

##How to start

```powershell
Import-Module -Name Poverb
```

##How To use it
Currently the output is only a string that has the regular expression you desire.

## API documentation

```PowerShell
	Get-RegexFromVerbex -Verbex {
		startofline
		then "http"
		maybe "s"
		then "://"
		maybe "www."
		anythingbut " "
		endofline
	}
```  

the output is:  

```
	'^(?:http)(?:s)?(?:://)(?:www\.)?(?:[^\ ]*)$'
```
## Other implementations  
You can view all implementations on [VerbalExpressions.github.io](http://VerbalExpressions.github.io)

##References
1. [Jim Hollenhorst - The 30 Minute Regex Tutorial](http://www.codeproject.com/Articles/9099/The-30-Minute-Regex-Tutorial) 
1. [VerbalExpressions.github.io](http://VerbalExpressions.github.io)  
1. [Peder Søholt](https://github.com/VerbalExpressions/CSharpVerbalExpressions) 
1. [Karl Prosser for writing Invoke-Ternary filter](http://karlprosser.com/coder/)  
1. [Doug Finke](http://dougfinke.com/blog/)  
  - [For tweeting about Verbal expressions](https://twitter.com/dfinke/statuses/368724976032964609)
  - [For writing about DSLs in his book](http://shop.oreilly.com/product/0636920024491.do) 

  
