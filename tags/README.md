# Sklik Retargeting tag

Allows you to easily create Sklik retargeting tag with 2 types of of specific parameters

1. **Standard Dynamic Retargeting Params**

   `seznam_pagetype`, `seznam_itemId`, `seznam_category` according to Seznam's official instructions [CZ](https://napoveda.sklik.cz/typy-cileni/dynamicky-retargeting/pokrocile-nastaveni-rtg-kodu/)/[EN](https://napoveda.sklik.cz/en/dynamic-retargeting/)

   Just pass GTM Variables and they will be passed to Sklik accordingly (pass an empty string or undefined value to pass nothnig)

2. **Custom Variables**

   Similar to Google Ads Custom variables. Feel free to define a variable name and pass a static value (dumb) or GTM Variable (better) 

   If the variable value is empty, the parameter won't be passed

   Each variable is passed as Query URL parameter e.g. `?my_variable=myvalue`

   Inside Sklik you should be able to create retargeting auditions based on the "fact" the user visited a URL containing 
"my_variable=myvalue"

## GTM "Installation" Instructions

To import a template file into your Google Tag Manager container, follow these steps:

1. Download the .tpl file you want to import.
1. Go to Google Tag Manager > **Templates** (left side menu)
1. Create a new template in **Tag Templates** section (a **New** button)
1. In the top right corner open "action menu" (3 dots next to Save button) **Click Import**
1. Select the .tpl file from your computer.
1. Click **Save** button in top right corner.
1. Close the Template editor (top left corner)

Now you have the tag template in the GTM Container.

## Creating the Tag from the Custom Template

1. Go to the **Tags** menu
1. Click **New** button
1. Same as any other tag ... click on **Tag Configuration** 
1. Find the Custom Template tag in **Custom** section (right below Custom HTML and Custom image tags)

You snouldn't need any more instructions from this point.
