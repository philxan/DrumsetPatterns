Drumset Patterns
================
DrumsetPatterns is a MuseScore 3.3+ &amp; MuseScore 4.x plugin that generates drumset notation in a variety of styles. It's as simple selecting, a style, a particular pattern, and the number of bars you need to fill, and letting Drumset Patterns do all the hard work of entering the notation.   With a little bit of work, you can also include your own favourite patterns!

Typically not many musicians are very familiar with drumset notation, or the various rhythms and variations used in particular styles. It's also easy to exhaust ideas, and quickly become frustrated that the drums don't sound right. Additionally, entering drumset notation in MuseScore can be slow and difficult, especially for many bars. 
It was from these problems that Drumset Patterns was born - as an easy way to enter drumset patterns from a library of sources. 

Usage
-----
Firstly, select the number of bars in a single staff that you want to fill with a drumset pattern.  (Of course this should be a Drumset instrument, as the entered notes won't make much sense for a tuned instrument!). Only a single staff should be selected, and at least one bar. (Note: there may be some issues with selecting the last bar. If you find the pattern isn't generated, select everything _except_ the last bar, and try again. 

Having selected the bars to enter, run the Drumset Patterns plugin.

The **Source** combobox lists the various source files in use. These are typically used to separate different styles such as Rock, Funk, Swing, etc. The Categories and Patterns  will be filtered by the selected source. You can also leave this as All to see the patterns from all the different source files.   Note that changing the selected Source will automatically select All Categories. 

The **Category** combobox lists the various different categories avaiable, given the Source.  Each pattern is tagged with categories to help identify the common characteristics of the pattern. These can include the time signature, the style, whether the pattern is intended for slower or faster tempos etc. Select the category to futher filter the patterns to choose from. 

The **Fill** checkbox can be used to filter to only those patterns intended to be used as a fill - a short pattern for the end of phrases 

The **Pattern** listbox shows all the patterns that meet the above selection criteria. When a pattern is selected, the text _in italics_ below the patterns list shows all the Categories associated with the selected pattern, as well as the length of the selected pattern (in bars). All the included patterns are bar, 2 bars, or 4 bars in length. 

The **Apply** button will insert the selected pattern into the bars selected in the score. 

Note: Applying a pattern will insert as many copies of the pattern that will fit in the selected bars.  This may not match the full length of the pattern. For example, if 3 bars are selected, and... 
  - you select a pattern that is 1 bar long, it will be inserted 3 times (once in each bar)
  - you select a pattern that is 2 bars long, then the full pattern will be insered in bars 1 and 2, and then just the first bar of the pattern will be insered in bar 3.
  - you select a pattern that is 4 bars long, tehn only the first 3 bars of the pattern will be inserted.

Note also that time signature categories are only indications of how the pattern is intended to be used - it is not at all restrictive. It is certainly possible to use a pattern intended for 6/8 in 4/4, with some very interesting and possibly useful results! it will be likley that there will be incomplete bars at the end. But try it - it can result in some fun rhythms and unexpected fills!

Installation
-------------
To install the plugin:
1. Download the file DrumsetPatterns-1.0.zip
1. Expand the zip file. The result is a folder "WalkingBass-1.0"
1. Move the WalkingBass folder into your MuseScore Plugins folder, which can be found here (for MuseScore 4)
   * Windows: %HOMEPATH%\Documents\MuseScore4\Plugins
   * Mac: ~/Documents/MuseScore4/Plugins
   * Linux: ~/Documents/MuseScore4/Plugins
   * for MuseScore 3.3, replace "MuseScore4" with "MuseScore3" in the paths above. 
1. Launch MuseScore
1. Select the menu item Plugins > Plugin Manager...
1. Enable Drumset Patterns
   
To use the plugin:
1. Select the menu item Plugins > Drumset Patterns The Drumset Patterns dialog will be opened. 
1. Select any number of bars in the staff where you want the drumset patterns to be generated.  This should be a drumset instrument staff. 
1. Follow the instructions above to select an appropriate patten, and click Apply.

Included Patterns
-----------------
There are a number of patterns included, in various source files. 
* **Blues** a variety of Blues, Blues Rock and R&B patterns. Predominantly in 6/8. 
* **Caribbean** Calypso, Reggae, and Soca
* **Cuban** Afro-Cuban 6/8, and Guaguanco 
* **Dance** Electronic, Dance & Hip-hop
* **Funk** Funk and funk infused Rock, Pop & Disco 
* **Fusion** Fusion and Steve Gadd inspired grooves
* **Latin** Baion, Boogaloo, Bossa Nova, Cha-Cha, Gospel-Latin, Mambo, Samba & Songo
* **Odd Time** 5/4, 7/4 and 6/4 grooves
* **Rock** Rock, Rock-pop and Indie-Rock patterns
* **Shuffle** Shuffle and Halftime Shuffle grooves
* **Swing** Classic Swing, Basie grooves and jazz rhythms

Creating Your Own Patterns
--------------------------
Also included is the _template.dp_ file.  This can be used as a template for creating your own patterns. This text file contains all the information needed to create patterns for use by the plugin. The first step will be uncomment the Sample Pattern at the end of the file, and reload the plugin. The Template source and Sample Pattern will be included in the dialog. 

Known Limitations
-----------------
* At times there are issues with generating a pattern in the last bar of a score.
* Drumset Patterns doesn't display correctly in MuseScore's dark mode. This is appears to be an issue with the Qt control set. 
* Do not use the '5' as the number of 16th notes in a pattern. Instead, use a tie (+) from one to another. (e.g. 1S+ 4S.)
* The smallest note that be generated is a 16th note. Currently 32nd notes aren't supported.
* Triplets are also not supported at this time. 
