<#
    .DESCRIPTION
    Simple PowerShell function to create a Jekyll md file with the required data.

    .NOTES
    Author: Patrick Cull
    Date: 2020-03-17
    
    .EXAMPLE
    New-JekyllBlogPost -PostTitle "My First Blogpost" -Tags "powershell", "automation"

    This example creates the md file with "My First Blogpost" as the title with the powershell and automation tags.
    It uses the current datetime as the date in the md file and the filename itself.
#>
function New-JekyllBlogPost {
    param(
        #Title of the blog post. Used in the md file and the file name itself.
        [Parameter(Mandatory)]
        [string] $PostTitle,

        #Tags for the blog bost.
        [string[]] $tags,

        #Timestamp used on the blogpost.
        [string] $datetime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss"),

        #Local directory of jekyll posts. File gets created here.
        [string] $LocalPostDirectory = "C:\GitHub\paddycull.github.io\_posts",

        #By default the function autommatically opens the md file when it's created. This switch stops that.
        [switch] $DoNotOpen
    )
    #Join the tags so they're in the correct format for the md file.
    $tagsjoined = $tags -join ', '

    #This is what the md file gets created with.
    $CreateString = @"
---
layout: post
title: $PostTitle
date: $datetime
tags: [$tagsjoined]
---
"@

    #Get the current date in the format required for the filename.
    $PostDateForFile = (Get-Date -Format "yyyy-MM-dd").ToString() + "-"

    #Full path for the file being created.
    $BlogFilePath = "$LocalPostDirectory\${PostDateForFile}${PostTitle}.md"

    #If the file already exists, prompt the user before overwriting.
    if(Test-Path $BlogFilePath) {
        $ConfirmOverwrite = Read-Host "$BlogFilePath already exists. Do you want to overwrite it? (y/n)"

        if($ConfirmOverwrite -ne "y") {
            Throw "File already exists."
        }
    }

    #Create the file, needs to be encoded with ascii to work with Jekyll.
    $CreateString | Out-File "$LocalPostDirectory\${PostDateForFile}${PostTitle}.md" -Encoding ascii

    #Open the file unless user specified not to.
    if(!$DoNotOpen) {
        Invoke-Item $BlogFilePath
    }
}