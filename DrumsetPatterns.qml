import MuseScore 3.0
import FileIO 3.0
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0

//=============================================================================
// DrumsetPatterns v1.0
// MuseScore 3.3+
// MuseScore 4.x  
//
// A plugin to add some basic drumset patterns 
//
// (C) 2023 Phil Kan 
// PitDad Music. All Rights Reserved. 
// 
// Restrictions / Assumptions / Checks
// - 4/4 time
// - 16ths notes, 8ths & quarters only
// - initially a few common patterns for rock, jazz, funk, world music
// - make a "create your own" that allows the user to edit / create
//
// Change History
//
// To Do
// - buzzrolls (#)
// - display "Fill" for patterns with the Fill tag 
// - configuration page of which midi notes to play for which instruments
// - display as slashes  (probably as voice 3 or 4?, and hide the other voices?)
//
//=============================================================================

MuseScore {
  menuPath: "Plugins.Drumset Patterns"
  description: "Provides various standard drumset patterns."
  version: "1.0"
  id: pluginscope
 
  Component.onCompleted : {
    if (mscoreMajorVersion >= 4) {
      title = "DrumSet Patterns";
      thumbnailName = "DrumSetPatternsIcon.png";
    }
  }
  
  pluginType: "dialog"

//=============================================================================
// Some groove definitions to start with 
// Each pattern has a name, a comma separated list of categories, and two strings, one for each voice
// Voice 1: Hands - HH, Snare, cymbals Toms,  
// Voice 2: Bass drum, Foot HH
//
// Each entry in a voice is a number, and a letter 
// The number indicates the number of 16ths notes to be played -- e.g 2 = 8th name (quaver), 4 = quarter note (crotchet)
// - a zero indicates a rest for a 16th note. 
// - the code will need to condense the number of zeros to a particular note (1, 2, 4)
// - the number of 0s + the sum of other numbers should add to 16, no more, no less. 

// The letter indicates the instruments that will play that note
// the midi notes for the different instruments
// should this be configurable by the user maybe?
  property var instrumentNotes:
  {
    
    'B': 36,   // - Bass Drum
    'C': 49,   // - Crash
    'D': 61,   // - Ride Bell
    'H': 42,   // - HighHat -- hands, closed
    'O': 46,   // - HighHat -- hands, open
    'P': 44,   // - Highhat -- pedal (feet)
    'R': 51,   // - Ride
    'S': 38,   // - Snare
    'T': 37,   // - Rimshot

    'U': 54,    // - Tambourine
    'W': 56,    // - Cowbell
    'X': 52,    // - Chinese Symbol
    'Y': 55,    // - Splash
    'Z': 39,    // - Hand clap

    'I': 50,    // - High Tom
    'J': 47,    // - Medium Tom
    'K': 45,    // - Low Tom
    'L': 41,    // - Floor Tom
  }
     
  property var patterns:
  {
     "16ths": 
     { "File": "General", 
       "Categories": ["Rock", "Pop"],
       "Hands": "1H 1H 1H 1H - 1H 1H 1H 1H - 1H 1H 1H 1H - 1H 1H 1H 1H",  
       "Feet":  "4B          - 40          - 4B          - 40", },

     "HighHats": 
     { "File": "General", 
       "Categories": ["Rock", "Pop"],
       "Hands": "2H 2H - 2H 2H - 2H 2H - 2H 2H",
       "Feet":  "4B    - 40    - 4B    - 40",    },
              
    "Rock": 
    { "File": "General", 
      "Categories": ["Rock"],
      "Hands": "2H 2H - 2SH 2H - 2H 2H - 2SH 2H",
      "Feet":  "4B    - 4B     - 4B    - 4B",     },
              
    "Rock (1)": 
    { "File": "General", 
      "Categories": ["Rock"],
      "Hands": "2H 2H - 2HS 2H - 2H 2H - 2SH 2H",
      "Feet":  "4B    - 20  2B - 4B    - 20 2B",   },
  }
  
  property var categories: 
  [
    "All Categories",
  ]
  
  // used to add the patterns to the list dynamically
  ListModel 
  {
    id: patternsListModel
  }
  
  ListModel
  {
    id: categoriesListModel
  }
  
  ListModel
  {
    id: filesListModel
  }
  
//=============================================================================
// UI Definition
  height: 500;
  width: 360;
  
  ColumnLayout 
  {
    anchors.fill: parent
    id: 'drumsetPatternsMainLayout'
    
    Label
    {
      id: sourceFileLabel
      text: "Source: "
      font.bold: true
      Layout.topMargin: 10
      Layout.leftMargin: 10
      Layout.fillWidth: true
      anchors.top: parent.top
    }
    
    ComboBox 
    {
      id: filesCombo
      model: filesListModel
      Layout.leftMargin: 10
      Layout.rightMargin: 10
      Layout.fillWidth: true
      onCurrentIndexChanged: fileSelectionChanged()
      anchors.top: sourceFileLabel.bottom
    }
        
    Label
    {
      id: categoryLabel
      text: "Category: "
      font.bold: true
      Layout.topMargin: 10
      Layout.leftMargin: 10
      anchors.top: filesCombo.bottom
    }
    
    RowLayout
    {
      id: categoriesFillRow
      anchors.top: categoryLabel.bottom

      ComboBox 
      {
        id: categoriesCombo
        model: categoriesListModel
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true
        onCurrentIndexChanged: categorySelectionChanged()
      }
      
      CheckBox 
      {
        id: fillCheckBox
        text: "Fill"
        Layout.preferredWidth: parent.width / 4
        Layout.alignment: Qt.AlignRight
        onCheckedChanged: fillCheckBoxClicked()
      }
    }

    Label 
    {
      id: patternLabel
      text: "Pattern: "
      font.bold: true
      Layout.leftMargin: 10
      anchors.top: categoriesFillRow.bottom
    }
    
    ListView
    {
      id:patternsListView
      Layout.margins: 10
      Layout.fillWidth: true
      anchors.top: patternLabel.bottom
      anchors.bottom: dummySpacer.top
      focus: true

      model: patternsListModel
      delegate: Text 
      {
        text: name 
        width: patternsListView.width
        MouseArea 
        {
          anchors.fill: parent
          onClicked: patternsListView.currentIndex = index
        }
      }
      highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
      highlightFollowsCurrentItem: true
      onCurrentItemChanged: selectedPatternChanged();
    }
    
    Label 
    {
      id: dummySpacer
      anchors.bottom: selectedPatternCategoriesLabel.top
      Layout.margins: 10
    }
    
    Label 
    {
      id: selectedPatternCategoriesLabel
      font.italic: true
      Layout.fillWidth: true

      Layout.margins: 20
      anchors.bottom: applyButton.top
    }
    
    RoundButton 
    {
      id: applyButton
      text: qsTranslate("PrefsDialogBase", "Apply")
      font.bold: true
      radius: 5
      anchors.bottom: drumsetPatternsMainLayout.bottom
      onClicked: applyPattern()
    }
  }
  
//=============================================================================
  MessageDialog 
  {
    id: errorDialog
    visible: false
    title: "DrumSet Patterns Error"
    text: "Lowest Note and Range must be numeric values"
    onAccepted: {
      close();
    }
  }
  

//=============================================================================
// Read .dp files and parse them to add more styles

  Timer 
  {
    id: collectFiles
    interval: 25
    running: false
    onTriggered: readDrumPatternFiles();
  }
  
  FolderListModel
  {
    id: dsFiles
    nameFilters: ["*.dp"]
    showDirs: false
  }
  
  
  FileIO
  {
    id: patternFile
    onError: console.log("FileIO Error: " + msg)
  }
 
  function readDrumPatternFiles()
  {
    filesListModel.clear();
    filesListModel.append({"name": "All"});
    for (var i = 0; i < dsFiles.count; i++) 
    {
      var fileName = dsFiles.get(i, "fileName")
      parseDrumPatternFile(fileName)
    }
    
    // setup the plugin category data & UI etc.
    setDefaults();
  }
  
  function parseDrumPatternFile (filename)
  {
    patternFile.source = dsFiles.folder + filename;

    // to add a category based on filename, but remove the ".dp" extension
    var fileNameTrimmed = filename.substr(0, filename.length-3).trim();    
    var categories = [];
         
    var fileContents = patternFile.read();
    var lines = fileContents.split(/\r?\n/);  
    var patternAdded = false;

    for (var lineNo = 0; lineNo < lines.length; lineNo++)
    {
      var line = lines[lineNo];
      if (line.startsWith ("//")) continue;
      if (line.trim().length == 0) continue;
      
      // not a comment, or blank, so assume it's a pattern name, followed by categories, hands and feet.
      var patternName = line.trim();
      var categoriesString = lines[++lineNo].trim()
      var hands = lines[++lineNo].trim()
      var feet = lines[++lineNo].trim()
      
      // transform the categories to a string list, with each string trimmed
      categories = [];
      var categoriesStrings = categoriesString.split(',');
      categoriesStrings.sort();
      for (var c = 0; c < categoriesStrings.length; c++)
      {
        categories.push(categoriesStrings[c].trim());
      }
      categories.sort();

      // add to patterns!
      var nameToAdd = patternName.trim()
      var varNo = 0

      while (! (patterns[nameToAdd] === undefined))
      {
         varNo++;
         nameToAdd = patternName.trim() + " (" + varNo + ")";
      }
                  
      patterns[nameToAdd] = {
        "File":fileNameTrimmed, 
        "Categories": categories, 
        "Hands": hands, 
        "Feet": feet };
      patternAdded = true;
    }

    if (patternAdded) 
    {
      filesListModel.append({"name": fileNameTrimmed});    
    }
  }

//=============================================================================
//

  function fileSelectionChanged()
  {
    var selectedFileIndex = filesCombo.currentIndex;
    var selectedFile = filesListModel.get(selectedFileIndex).name;
    var allFiles = (selectedFile == "All")
    
    var cats = [];
    
    // TODO: ideally this should also be mapped when we read the files... 
    for (var p in patterns)
    {
      var pattern = patterns[p];
      if (!allFiles && (pattern.File != selectedFile)) continue;
      for (var c in pattern.Categories) 
      {
        if (arrayContains(cats, pattern.Categories[c])) continue;
        cats.push(pattern.Categories[c]);
      }
    }
        
    cats.sort();

    categoriesListModel.clear();
    categoriesListModel.append({"name": "All Categories"});
    
    for (var fc in cats)
    {
      categoriesListModel.append({"name": cats[fc]});
    }
             
    categoriesCombo.currentIndex = categoriesCombo.find("All Categories");           // All Categories.
  }

//=============================================================================
//

  function categorySelectionChanged()
  {
    var selectedFileIndex = filesCombo.currentIndex;
    var selectedFileName = filesListModel.get(selectedFileIndex).name;

    var selectedCategoryIndex = categoriesCombo.currentIndex;
    if (selectedCategoryIndex < 0) return;

    var selectedCategoryName = categoriesListModel.get(selectedCategoryIndex).name;

    patternsListModel.clear();
    var patternsList = [];
    var allFiles = (selectedFileName == "All");
    var allCategories = (selectedCategoryName == "All Categories");

    for (var p in patterns)
    {
      var pattern = patterns[p];
      if (   (allFiles || pattern.File == selectedFileName) 
          && (allCategories || arrayContains(pattern.Categories, selectedCategoryName))
          && ((fillCheckBox.checkState == Qt.Unchecked) || arrayContains(pattern.Categories, "Fill"))
         )
      {      
        patternsList.push(p);
      }
    }
    
    patternsList.sort();

    for (var p in patternsList)
    {
      patternsListModel.append({"name": patternsList[p]})
    }
    
    patternsListView.currentIndex = 0;
  
  }

//=============================================================================
  
   function fillCheckBoxClicked()
   {
      // triggers a refresh of the list of patterns
      categorySelectionChanged();
   }
   
//=============================================================================

  function selectedPatternChanged()
  {
    selectedPatternCategoriesLabel.text = "";
    if (patternsListView.currentIndex <0 )
    {
      return;
    }

    if (patternsListView.currentItem == null) return;
    
    var selectedPattern = patterns[patternsListView.currentItem.text];

    var bars = selectedPattern.Hands.split('|').length;
    
    // make the list of categories into a single string
    selectedPatternCategoriesLabel.text = selectedPattern.Categories.join(", ") + "\r\n" + bars + " bar" + ((bars > 1) ? "s" : ""); 
    
  }
  
//=============================================================================

  function arrayContains(arr, val)
  {
    for (var a in arr)
    {
      if (arr[a] === val) return true;
    }
    return false;
  }
  
//=============================================================================

  function setDefaults()
  {
    // build the list of categories included in each pattern
    // TODO: this should probably be done when we're reading the files, rather than later... 
    for (var p in patterns)
    {
      var pattern = patterns[p]

      for (var c in pattern.Categories) 
      {
        var cat = pattern.Categories[c].trim()
        if (arrayContains(categories, cat)) continue;
        categories.push(cat);
      }
    }  
    
    // populate the categories combobox
    categories.sort();
    categoriesListModel.clear();
    categoriesListModel.append({"name": "All Categories"});
    
    for (var c in categories)
    {
      categoriesListModel.append({"name": categories[c]});
    }  
      
    // this will trigger the categories listview to be populated with "All Categories" initially
    // which will trigger the patterns listview to be populated with all patterns
    filesCombo.currentIndex = filesCombo.find("All");
  }
   
  function initialiseScoreChanges()
  {
    curScore.startCmd();
  }
  
  function finaliseScoreChanges()
  {
    curScore.endCmd()
  }

//=============================================================================

  function applyPattern()
  {
    if (!validScoreSelection())
    {
      return;
    }
    
    var selectedPattern = patterns[patternsListView.currentItem.text];
    
    var cursor = curScore.newCursor()
    cursor.rewind(Cursor.SELECTION_START);
    var startTick = cursor.tick;
    cursor.rewind(Cursor.SELECTION_END);
    var endTick;

    // this can happen if an element is selected, not an entire bar
    if (startTick == cursor.tick) 
    {
      return; 
    }    
    
    // this happens when the selection includes  the last measure of the score.
    // rewind(Cursor.SELECTION_END) goes behind the last segment (where there's none) and sets tick=0
    if (cursor.tick == 0) {
      endTick = curScore.lastSegment.tick; // last possible one is a 16th prior to the end
    } else {
      endTick = cursor.tick;
    }

    initialiseScoreChanges();
    var staffIdx = curScore.selection.startStaff
    

    cursor.rewind(Cursor.SELECTION_START);
    addVoice (0, selectedPattern.Hands, cursor, staffIdx, startTick, endTick);
    
    cursor.rewind(Cursor.SCORE_START);
    cursor.rewindToTick(startTick);
    addVoice (1, selectedPattern.Feet, cursor, staffIdx, startTick, endTick);
    
    finaliseScoreChanges();
    
  }
  
//=============================================================================
// Ensure the user has selected at least one bar in only one staff

  function validScoreSelection()
  {
  
    if (curScore.selection == undefined || curScore.selection.elements.length < 1)        // no selection
    { 
      errorDialog.text = "Error: No bars are selected.\nPlease select at least one entire bar in only one staff";
      errorDialog.open();
      return false;
    }
    
    if (curScore.selection.endStaff - curScore.selection.startStaff > 1)
    {
      errorDialog.text = "Error: More than one staff is selected\nPlease select at least one bar in only one staff";
      errorDialog.open();
      return false;
    }
    
    return true;
  
  }

//=============================================================================

  function addVoice (voice, pattern, cursor, staffIdx, startTick, endTick) 
  { 
    var duration = 0
    var instruments = ""

    cursor.rewind(Cursor.SCORE_START);
    cursor.rewindToTick(startTick);
    
    cursor.staffIdx = staffIdx;
    cursor.voice = voice;
   
    var i = 0;
    var t;
    while (cursor.segment && cursor.tick < endTick)
    {
       t = cursor.tick;    
      
      if (i >= pattern.length) 
      { 
        i = 0;  
      }

      // ignore spaces in the pattern
      while (pattern[i] == " ") 
      {
        i++;
      }
        
      // reset which instruments are being used.
      instruments = "";
    
      // first deal with a number - if not, just ignore it & continue
      if (!("123456789").includes(pattern[i]))
      {
        i++;
        continue;
      }
        
      duration = pattern[i];

      i++;
      if (i >= pattern.length) 
      {
        i = 0;
      }

      // collect the list of instruments, until a space or other separation marker
      while (i < pattern.length && !" -|".includes(pattern[i]))
      {
        instruments = instruments + pattern[i];
        i++;
      }

      if (instruments == "0" || instruments == ".") 
      {
        addRest(duration, cursor);
      }
      else 
      {
        addNotes(duration, instruments, cursor);
      }
       
      if (cursor.tick == t) 
      {
        // at the same tick after adding note or rest!, this is an indication that we've reached the 
        // end of the score, so we need to stop!
        break;
      }
      
      i++;
      if (i >= pattern.length) 
      {
        i = 0
      }

    }    

  }
  
//=============================================================================

  function addRest(duration, cursor)
  {
    setDuration(duration, cursor);
    cursor.addRest();
  }

property var tieFromTick: -1;  
  
//=============================================================================
  function addNotes(numberOf16ths, instruments, cursor)
  {
    var addAccent = false;  
    var addTremolo = false; 
    var tieFromHere = false;
    setDuration(numberOf16ths, cursor);

    // add all the notes. If there is an accent, we'll add that after all the notes
    for (var inst = 0; inst < instruments.length; inst++) 
    {
      if (instruments[inst] == '+') 
      {
        tieFromHere = true;
        continue;
      }    
      
      if (instruments[inst] == '!') 
      {
        addAccent = true;  
        continue;
      }
      
      if (instruments[inst] == '#') 
      {
        addTremolo = true;  
        continue;
      }
    
      var notePitch = instrumentNotes[instruments[inst]];   
      var addToChord = inst > 0; // false for first note added, true otherwise
      cursor.addNote(notePitch, addToChord);
    }

    // gosh this is ugly
    // it causes the note at the start of the tie to be selected, which mau cause an audio event
    // and it resets the selection.. surely there's a better way!
    if (tieFromTick >= 0)
    {
      var currentTick = cursor.tick;
      cursor.rewindToTick(tieFromTick);
      for (var i = 0; i < cursor.element.notes.length; i++)
      {
        curScore.selection.select(cursor.element.notes[i], false);
        cmd("tie");
      }
      cursor.rewindToTick(currentTick);
      tieFromTick = -1;
    }

        // there might be a problem here when trying to add an accent to roll to last segment
    if (addAccent || tieFromHere)
    {
      cursor.prev();          // cursor has been moved on the next segment, so need to go back
      if (addAccent) 
      {
        var s = newElement(Element.ARTICULATION); 
        s.symbol = "articAccentAbove"
        cursor.add(s);
      }
      if (tieFromHere)
      {
        tieFromTick = cursor.tick;
      }
      cursor.next();
    }
   
    
  }  


//=============================================================================

  property var durations:
  {
    1: [1, 16], 
    2: [1, 8],
    3: [3, 16], 
    4: [1, 4],
    5: [5, 16], 
    6: [3, 8], 
    7: [7, 16], 
    8: [1, 2]
  }

  function setDuration(numberOf16ths, cursor)
  {
    if (durations[numberOf16ths] == "undefined") return;
    cursor.setDuration(durations[numberOf16ths][0], durations[numberOf16ths][1]);
  }
  
//=============================================================================

  onRun: 
  {
    if (!       // MS 3.3 & higher, and MS 4.x are all supported. 
      ((mscoreMajorVersion == 3 && mscoreMinorVersion >= 3) ||
       (mscoreMajorVersion == 4)
       ))
    {
      versionError.open()
      
      if (typeof(quit) === 'undefined') 
      { 
        Qt.quit() 
      }
      else 
      { 
        quit() 
      }
      
      return;
    }
    
    var workingDirectory = Qt.resolvedUrl(".");
    dsFiles.folder = workingDirectory;
    
    // the timer is required so that the FolderListModel can do its work, and has time to read
    // the plugin directory for the .dp files.
    // after parsing any files, it will then call setDefaults() to set up the plugin data
    collectFiles.running = true;
    
    // setDefaults();
  }
      
}
