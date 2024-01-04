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



